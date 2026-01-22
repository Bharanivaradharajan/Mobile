
class BlogPost {
  final String title;
  final String category;
  final String date;
  final String readTime;
  final String imageUrl;

  BlogPost({
    required this.title, 
    required this.category, 
    required this.date, 
    required this.readTime,
    required this.imageUrl,
  });
}

// Simulated data fetch from "API" or "Database"
final List<BlogPost> blogPosts = [
  BlogPost(
    title: "The Future of Minimally Invasive Spine Surgery",
    category: "SURGERY",
    date: "Jan 20, 2026",
    readTime: "5 min",
    imageUrl: "https://www.osswf.com/wp-content/uploads/2024/11/OSSWF-Blog-Thumbnail-Feature-Image.png",
  ),
  BlogPost(
    title: "AI in Hip Replacement: Precision Planning",
    category: "TECHNOLOGY",
    date: "Jan 18, 2026",
    readTime: "8 min",
    imageUrl: "https://media.istockphoto.com/id/1220958078/photo/doctor-and-patient-doctor-examining-of-the-leg-from-the-knee-and-ankle-and-training-broken.jpg?s=612x612&w=0&k=20&c=G1pyXV8chJBQMT2cN5ZB12tjpcd9QnJlwW9Q0HzZcvA=",
  ),
  BlogPost(
    title: "Recovering from ACL Tears: Modern Protocols",
    category: "REHAB",
    date: "Jan 15, 2026",
    readTime: "12 min",
    imageUrl: "https://www.biaphysio.com/wp-content/uploads/2019/07/Torn-ACL-pic.png",
  ),
];