/// Who owes whom for [LoansTable.direction].
abstract final class LoanDirection {
  /// Money you lent to someone else (a loan you gave).
  static const lentByMe = 'lent_by_me';

  /// Money you borrowed and must pay back (separate from loans).
  static const borrowedByMe = 'borrowed_by_me';

  static bool isLoan(String direction) => direction == lentByMe;
  static bool isPayback(String direction) => direction == borrowedByMe;

  @Deprecated('Use isLoan')
  static bool isReceivable(String direction) => isLoan(direction);

  @Deprecated('Use isPayback')
  static bool isBorrowed(String direction) => isPayback(direction);
}
