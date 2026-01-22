
class DoctorModel {
  final String name;
  final String specialty;
  final String city;
  final String hospital;
  final String rating;
  final String imageUrl;
  final String websiteUrl;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.city,
    required this.hospital,
    required this.rating,
    required this.imageUrl,
    required this.websiteUrl,
  });
}
// Add this helper list to your doctor_data.dart file
final List<String> availableCities = [
  "All",
  "Chennai",
  "Delhi",
  "Banglore",
  "Hyderabad",
  "Punjab",
];

// Simulated JSON Data
final List<DoctorModel> doctorData = [
  DoctorModel(
    name: "Dr Gopala Krishnan",
    specialty: "Orthopedics",
    city: "Chennai",
    hospital: "Apollo Hospitals",
    rating: "4.9 and 36 Years Experience",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-01/dr-gopala-krishnan-orthopaedics-in-chennai.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/chennai/dr-gopala-krishnan",
  ),
  DoctorModel(
    name: "Dr. Jairam Chandra Pingle",
    specialty: "Joint Replacement Surgeon & Orthopaedist",
    city: "Hyderabad",
    hospital: "Apollo Health City, Jubilee Hills",
    rating: "5.0",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-10/jai-ram-pingle.jpg",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/hyderabad/dr-jairamchander-pingle",
  ),
  DoctorModel(
    name: "Dr Vinod Sukhija",
    specialty: "JOINT REPLACEMENTS (KNEE & HIP) & TRAUMATOLOGY",
    city: "Delhi",
    hospital: "Apollo Hospitals, Delhi",
    rating: "5.0",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-07/dr-vinod-sukhija.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/delhi/dr-vinod-sukhija",
  ),
  DoctorModel(
    name: "Dr. Prof Raju Vaishya",
    specialty: "Knee & Hip Surgery (Total Joint Replacement (incl. Robotic) & Arthroscopic Surgery)",
    city: "Delhi",
    hospital: "Apollo Hospitals, Delhi",
    rating: "5.0,40+ Years  experience",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-01/dr-raju-vaishya-orthopaedics-in-delhi.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/delhi/dr-prof-raju-vaishya",
  ),
  DoctorModel(
    name: "Dr Sanjay Pai",
    specialty: "Hip and knee replacements",
    city: "Banglore",
    hospital: "Apollo Speciality Hospital, Jayanagar",
    rating: "5.0",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-07/dr-sanjay-pai.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/bangalore/dr-sanjay-pai",
  ),
  DoctorModel(
    name: "Dr Surendranath Shetty B",
    specialty: "Orthopaedic Surgeon",
    city: "Banglore",
    hospital: "Apollo Speciality Hospital, Jayanagar",
    rating: "5.0,37+ Years  experience",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-07/dr-surendranath-shetty-b.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/bangalore/dr-surendranath-shetty-b",
  ),
  DoctorModel(
    name: "Dr Mayil Vahanan Natarajan",
    specialty: "Orthopaedics & Joint Replacement",
    city: "Chennai",
    hospital: "Apollo Cancer Centre",
    rating: "5.0",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-07/dr-mayil-vahanan-natarajan.png",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/chennai/dr-mayil-vahanan-natarajan",
  ),
  DoctorModel(
    name: "Dr Kapil Kumar",
    specialty: "Orthopaedics Specialist",
    city: "Delhi",
    hospital: "Apollo Hospitals, Delhi",
    rating: "5.0",
    imageUrl: "https://drupal-cdn-hfaeddcdbng5hfbg.a01.azurefd.net/sites/default/files/2025-04/Dr%20Kapil%20Kumar",
    websiteUrl: "https://www.apollohospitals.com/doctors/orthopedician/delhi/dr-kapil-kumar",
  ),
  DoctorModel(
    name: "Dr. Ramesh Kumar Sen",
    specialty: "Orthopaedics & Joint Replacement, Arthroscopy & Sports Injury",
    city: "Punjab",
    hospital: "Max Hospital - Mohali",
    rating: "5.0",
    imageUrl: "https://d35oenyzp35321.cloudfront.net/Dr_Ramesh_Sen_b55d3e3ec4.jpg",
    websiteUrl: "https://www.maxhealthcare.in/doctor/dr-ramesh-kumar-sen",
  ),
  DoctorModel(
    name: "",
    specialty: "",
    city: "",
    hospital: "",
    rating: "5.0",
    imageUrl: "",
    websiteUrl: "",
  ),
  DoctorModel(
    name: "",
    specialty: "",
    city: "",
    hospital: "",
    rating: "5.0",
    imageUrl: "",
    websiteUrl: "",
  ),
  
];