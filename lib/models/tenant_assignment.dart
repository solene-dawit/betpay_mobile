class TenantAssignment {
  final String propertyName;
  final String roomNumber;
  final int floorNumber;
  final double monthlyRent;
  final String currency;
  final int dueDay;
  final String dueDate;
  final String status;

  const TenantAssignment({
    required this.propertyName,
    required this.roomNumber,
    required this.floorNumber,
    required this.monthlyRent,
    required this.currency,
    required this.dueDay,
    required this.dueDate,
    required this.status,
  });

  // Temporary data — later this will come from the Go backend.
  factory TenantAssignment.simulated() {
    return const TenantAssignment(
      propertyName: 'Sunshine Apartment',
      roomNumber: '204',
      floorNumber: 2,
      monthlyRent: 8500,
      currency: 'ETB',
      dueDay: 5,
      dueDate: '2026-09-05',
      status: 'OVERDUE',
    );
  }
}