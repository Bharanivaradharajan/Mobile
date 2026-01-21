import 'ortho_data_model.dart';

class OrthoContentDB {
  static List<OrthoArticle> allArticles = [
    // 1. SPINE SECTION
    OrthoArticle(
      section: "Spine & Vertebrae",
      title: "Vertebral Compression Fractures",
      description: "A collapse of a vertebra, often caused by osteoporosis or trauma, leading to significant spinal deformity.",
      imageUrl: "assets/images/spine_fx.jpg",
      points: ["Mid-back pain", "Loss of height", "Kyphoplasty indicated"],
    ),
    OrthoArticle(
      section: "Spine & Vertebrae",
      title: "Fractures",
      description: "A collapse of a vertebra, often caused by osteoporosis or trauma, leading to significant spinal deformity.",
      imageUrl: "assets/images/spine_fx.jpg",
      points: ["Mid-back pain", "Loss of height", "Kyphoplasty indicated"],
    ),
    
    // 2. TRAUMA SECTION
    OrthoArticle(
      section: "Trauma & Fractures",
      title: "Femoral Shaft Fractures",
      description: "High-energy injuries requiring urgent stabilization to prevent systemic complications and blood loss.",
      imageUrl: "assets/images/femur_fx.jpg",
      points: ["Winquist Classification", "Intramedullary Nailing", "Blood loss risk"],
    ),

    // 3. JOINTS SECTION (New)
    OrthoArticle(
      section: "Joints & Reconstruction",
      title: "Osteoarthritis of the Knee",
      description: "Degenerative wear of the articular cartilage resulting in pain, stiffness, and loss of joint space.",
      imageUrl: "assets/images/knee_oa.jpg",
      points: ["Kellgren-Lawrence Grading", "Total Knee Arthroplasty", "Viscosupplementation"],
    ),

    // 4. UPPER LIMB (New)
    OrthoArticle(
      section: "Upper Limb",
      title: "Rotator Cuff Tears",
      description: "Injuries to the tendons connecting muscles to the humerus, common in athletes and aging populations.",
      imageUrl: "assets/images/rotator_cuff.jpg",
      points: ["Neer Stages", "Arthroscopic Repair", "Supraspinatus involvement"],
    ),

    // 5. LOWER LIMB (New)
    OrthoArticle(
      section: "Lower Limb",
      title: "ACL Rupture",
      description: "A major ligament injury in the knee often caused by sudden deceleration or pivoting motions.",
      imageUrl: "assets/images/acl_tear.jpg",
      points: ["Lachman Test positive", "Bone-Patellar-Bone Graft", "Proprioception training"],
    ),

    // 6. PEDIATRIC ORTHO (New)
    OrthoArticle(
      section: "Pediatric Orthopaedics",
      title: "Clubfoot (CTEV)",
      description: "Congenital deformity where the foot is twisted inward and downward, requiring early intervention.",
      imageUrl: "assets/images/clubfoot.jpg",
      points: ["Ponseti Method", "Achilles Tenotomy", "Denis Browne splint"],
    ),

    // 7. SPORTS MEDICINE (New)
    OrthoArticle(
      section: "Sports Medicine",
      title: "Meniscal Injuries",
      description: "Tears in the shock-absorbing cartilage of the knee, categorized by zone and tear morphology.",
      imageUrl: "assets/images/meniscus.jpg",
      points: ["McMurray Test", "Red-Red Zone (healing potential)", "Partial Menisectomy"],
    ),

    // 8. BONE ONCOLOGY (New)
    OrthoArticle(
      section: "Tumors & Oncology",
      title: "Osteosarcoma",
      description: "The most common primary malignant bone tumor, typically affecting the metaphyseal region of long bones.",
      imageUrl: "assets/images/osteosarcoma.jpg",
      points: ["Codman Triangle sign", "Neoadjuvant Chemotherapy", "Limb Salvage Surgery"],
    ),
  ];
}