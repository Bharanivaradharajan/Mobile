class DeepDiveModel {
  final String title;
  final String content;
  final String author;
  final String readTime;

  DeepDiveModel({
    required this.title,
    required this.content,
    required this.author,
    required this.readTime,
  });
}

final List<DeepDiveModel> deepDivePosts = [
  DeepDiveModel(
    title: "The 2026 Bio-Logic Shift",
    content: "Orthopaedic surgery is no longer just about mechanical alignment; it's about biological integration. The move toward 'smart implants' has reduced revision rates by 22% in the last fiscal quarter.",
    author: "Dr. Aris Thorne",
    readTime: "4 min read",
  ),
  DeepDiveModel(
    title: "Neural Mapping Advancements",
    content: "Recent breakthroughs in peripheral nerve mapping allow surgeons to navigate complex trauma cases with sub-millimeter precision, preserving motor function in previously 'unrecoverable' scenarios.",
    author: "Dr. Sarah Chen",
    readTime: "6 min read",
  ),
  DeepDiveModel(
    title: "AI In Intraoperative Care",
    content: "Real-time haptic feedback loops are now being integrated into robotic arms, allowing for a 'synthetic touch' that mimics the resistance of healthy cortical bone versus osteoporotic tissue.",
    author: "Prof. Marcus Vane",
    readTime: "5 min read",
  ),
];