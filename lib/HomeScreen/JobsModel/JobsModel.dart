class Job {
  final String id;
  final String position;
  final String company;
  final String location;
  final double salaryMin;
  final double salaryMax;
  final String description;
  final String applyUrl;
  final String companyLogo;

  Job({
    required this.id,
    required this.position,
    required this.company,
    required this.location,
    required this.salaryMin,
    required this.salaryMax,
    required this.description,
    required this.applyUrl,
    required this.companyLogo,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      position: json['position'],
      company: json['company'],
      location: json['location'],
      salaryMin: json['salary_min'].toDouble(),
      salaryMax: json['salary_max'].toDouble(),
      description: json['description'],
      applyUrl: json['apply_url'],
      companyLogo: json['company_logo'],
    );
  }
}
