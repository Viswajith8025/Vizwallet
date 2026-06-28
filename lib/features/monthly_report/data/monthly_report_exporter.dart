import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';
import 'package:share_plus/share_plus.dart';

final monthlyReportExporterProvider =
    Provider<MonthlyReportExporter>((ref) => MonthlyReportExporter());

class MonthlyReportExporter {
  Future<File> exportJson(MonthlyClosingReport report) async {
    final dir = await _exportDir();
    final file = File(p.join(dir.path, _fileName(report, 'json')));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(report.toJson()),
    );
    return file;
  }

  Future<File> exportCsv(MonthlyClosingReport report) async {
    final rows = <List<String>>[
      ['Section', 'Metric', 'Value'],
      ['Income', 'Total income', formatPaise(report.incomePaise)],
      ['Expenses', 'Total expenses', formatPaise(report.expensesPaise)],
      ['Savings', 'Net savings', formatPaise(report.savingsPaise)],
      [
        'Savings',
        'Savings rate',
        '${report.savingsRatePercent.toStringAsFixed(1)}%',
      ],
      [
        'Spending',
        'Avg daily spend',
        formatPaise(report.averageDailySpendPaise),
      ],
      ['Spending', 'Cycle days', '${report.cycleDayCount}'],
    ];

    if (report.largestPurchase != null) {
      final lp = report.largestPurchase!;
      rows.add([
        'Highlight',
        'Largest purchase',
        '${lp.title} · ${formatPaise(lp.amountPaise)}',
      ]);
    }

    for (final cat in report.topCategories) {
      rows.add([
        'Category',
        cat.name,
        '${formatPaise(cat.totalPaise)} (${cat.sharePercent.toStringAsFixed(1)}%)',
      ]);
    }

    if (report.healthScore != null) {
      rows.add(['Health', 'Financial health score', '${report.healthScore}']);
    }

    for (final g in report.goalsAchieved) {
      rows.add(['Goal achieved', g.title, g.detail]);
    }
    for (final g in report.goalsMissed) {
      rows.add(['Goal missed', g.title, g.detail]);
    }

    final review = report.aiReview;
    if (review != null) {
      rows.add(['AI Review', 'Headline', review.headline]);
      for (final insight in review.insights) {
        rows.add(['AI Insight', '', insight]);
      }
      for (final rec in review.recommendations) {
        rows.add(['AI Recommendation', rec.title, rec.detail]);
      }
    }

    final buffer = StringBuffer();
    for (final row in rows) {
      buffer.writeln(row.map(_csvEscape).join(','));
    }

    final dir = await _exportDir();
    final file = File(p.join(dir.path, _fileName(report, 'csv')));
    await file.writeAsString(buffer.toString());
    return file;
  }

  Future<File> exportPng(MonthlyClosingReport report, Uint8List bytes) async {
    final dir = await _exportDir();
    final file = File(p.join(dir.path, _fileName(report, 'png')));
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> exportPdf(MonthlyClosingReport report) async {
    final generated =
        DateFormat('d MMM yyyy, h:mm a').format(report.generatedAt.toLocal());
    final theme = await PdfGoogleFonts.josefinSansRegular();
    final themeBold = await PdfGoogleFonts.josefinSansBold();

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(40),
          theme: pw.ThemeData.withFont(base: theme, bold: themeBold),
        ),
        build: (context) => [
          _pdfHeader(report, generated),
          pw.SizedBox(height: 20),
          _pdfSummaryGrid(report),
          if (report.aiReview != null) ...[
            pw.SizedBox(height: 24),
            _pdfSectionTitle('AI Monthly Review'),
            _pdfText(report.aiReview!.headline),
            _pdfText(report.aiReview!.subheadline),
            ...report.aiReview!.insights.map(_pdfBullet),
            pw.SizedBox(height: 12),
            _pdfSectionTitle('Recommendations'),
            ...report.aiReview!.recommendations.map(
              (r) => _pdfBullet('${r.title}: ${r.detail}'),
            ),
          ],
          pw.SizedBox(height: 24),
          _pdfSectionTitle('Cycle comparison'),
          _pdfComparison(report),
          pw.SizedBox(height: 20),
          _pdfSectionTitle('Top categories'),
          ...report.topCategories.map(_pdfCategoryRow),
          if (report.largestPurchase != null) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Largest purchase'),
            _pdfPurchaseRow(report.largestPurchase!),
          ],
          if (report.budgetBuckets.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Budget performance'),
            _pdfText(
              '${report.budgetOnTrackPercent.toStringAsFixed(0)}% of spending groups on track',
            ),
            ...report.budgetBuckets.map(_pdfBucketRow),
          ],
          pw.SizedBox(height: 20),
          _pdfSectionTitle('Subscriptions & loans'),
          _pdfText(
            'Subscriptions: ${formatPaise(report.subscriptions.cycleSpendPaise)} this month · '
            '${report.subscriptions.activeCount} active',
          ),
          _pdfText(
            'Loans: ${formatPaise(report.loans.pendingBorrowedPaise)} outstanding · '
            '${report.loans.overdueCount} overdue',
          ),
          if (report.healthScore != null) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Financial health'),
            _pdfText(
              'Score ${report.healthScore}/100 '
              '(${report.healthTrendDelta >= 0 ? '+' : ''}${report.healthTrendDelta})',
            ),
            _pdfText(report.healthMotivation),
          ],
          if (report.trendSummaries.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Spending trends'),
            ...report.trendSummaries.map(_pdfBullet),
          ],
          if (report.goalsAchieved.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Goals achieved'),
            ...report.goalsAchieved
                .map((g) => _pdfBullet('${g.title}: ${g.detail}')),
          ],
          if (report.goalsMissed.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _pdfSectionTitle('Goals missed'),
            ...report.goalsMissed
                .map((g) => _pdfBullet('${g.title}: ${g.detail}')),
          ],
          pw.SizedBox(height: 32),
          pw.Text(
            '${AppConstants.appName} · Confidential financial statement',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final dir = await _exportDir();
    final file = File(p.join(dir.path, _fileName(report, 'pdf')));
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> shareFile(File file, {required String subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }

  Future<void> printPdf(MonthlyClosingReport report) async {
    final file = await exportPdf(report);
    final bytes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  String _fileName(MonthlyClosingReport report, String ext) {
    final safe = report.cycleKey.replaceAll(':', '-');
    return 'vis-wallet-closing-$safe.$ext';
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<Directory> _exportDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'exports'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  pw.Widget _pdfHeader(MonthlyClosingReport report, String generated) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('0F3D5E'),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            AppConstants.appName,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'AI Monthly Review',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            report.cycleLabel,
            style: const pw.TextStyle(color: PdfColors.white, fontSize: 13),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Generated $generated',
            style: pw.TextStyle(
              color: PdfColor.fromHex('2DD4BF'),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfSummaryGrid(MonthlyClosingReport report) {
    return pw.Row(
      children: [
        _pdfMetricCard('Income', formatPaise(report.incomePaise)),
        pw.SizedBox(width: 10),
        _pdfMetricCard('Expenses', formatPaise(report.expensesPaise)),
        pw.SizedBox(width: 10),
        _pdfMetricCard('Savings', formatPaise(report.savingsPaise)),
      ],
    );
  }

  pw.Widget _pdfMetricCard(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _pdfSectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _pdfText(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 10)),
    );
  }

  pw.Widget _pdfBullet([String? text]) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 8, bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: const pw.TextStyle(fontSize: 10)),
          pw.Expanded(
            child: pw.Text(text ?? '', style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfComparison(MonthlyClosingReport report) {
    final c = report.comparison;
    final expenseDelta = c.expenseChangePercent;
    final savingsDelta = c.savingsChangePercent;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _pdfText('vs ${c.previousCycleLabel}'),
        _pdfText(
          'Expenses: ${formatPaise(c.previousExpensesPaise)} → '
          '${formatPaise(report.expensesPaise)}'
          '${expenseDelta != null ? ' (${expenseDelta >= 0 ? '+' : ''}${expenseDelta.toStringAsFixed(1)}%)' : ''}',
        ),
        _pdfText(
          'Savings: ${formatPaise(c.previousSavingsPaise)} → '
          '${formatPaise(report.savingsPaise)}'
          '${savingsDelta != null ? ' (${savingsDelta >= 0 ? '+' : ''}${savingsDelta.toStringAsFixed(1)}%)' : ''}',
        ),
      ],
    );
  }

  pw.Widget _pdfCategoryRow(CategoryReportLine cat) {
    return _pdfText(
      '${cat.name}: ${formatPaise(cat.totalPaise)} '
      '(${cat.sharePercent.toStringAsFixed(1)}%)',
    );
  }

  pw.Widget _pdfPurchaseRow(PurchaseHighlight p) {
    return _pdfText(
      '${p.title} · ${p.categoryName} · ${formatPaise(p.amountPaise)} · ${p.dateLabel}',
    );
  }

  pw.Widget _pdfBucketRow(BudgetBucketLine b) {
    return _pdfText(
      '${b.name}: ${formatPaise(b.spentPaise)} / ${formatPaise(b.allocatedPaise)} '
      '(${b.percentUsed.toStringAsFixed(0)}%)',
    );
  }
}
