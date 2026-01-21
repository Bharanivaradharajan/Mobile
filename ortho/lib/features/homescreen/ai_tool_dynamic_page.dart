import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AIToolPage extends StatefulWidget {
  final String toolName;
  final List<Color> themeColors;

  const AIToolPage({
    super.key,
    required this.toolName,
    required this.themeColors,
  });

  @override
  State<AIToolPage> createState() => _AIToolPageState();
}

class _AIToolPageState extends State<AIToolPage> {
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;
  String? _statusMessage;
  String? _selectedFileName;

  // --- FILE PICKER LOGIC ---
  Future<void> _pickFile(List<String> extensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );

      if (result != null) {
        setState(() {
          _selectedFileName = result.files.single.name;
        });
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  // --- MOCK AI PROCESSING ---
  void _processData() async {
    if (_textController.text.isEmpty && _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide text input or select a file")),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = "Uploading to RUSA 2.0 Secure Servers...";
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() => _statusMessage = "Running Neural Analysis...");
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
      _statusMessage = "Analysis Complete: Model successfully processed ${widget.toolName} request.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030708),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.toolName.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            
            // Render specific input fields based on the tool clicked
            if (widget.toolName == "NER Engine") _buildNERInput(),
            if (widget.toolName == "Summarizer") _buildSummarizerInput(),
            if (widget.toolName == "Predictor") _buildPredictorInput(),

            const SizedBox(height: 30),
            _buildActionButton(),
            
            if (_statusMessage != null) _buildResultOutput(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // --- DYNAMIC INPUT BUILDERS ---

  Widget _buildNERInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("CLINICAL TEXT INPUT"),
        _buildTextArea("Enter clinical findings for entity extraction..."),
        _buildDivider(),
        _buildSectionLabel("RESEARCH SOURCES"),
        _fileUploadCard("Upload Article (PDF)", Icons.picture_as_pdf, ['pdf']),
        const SizedBox(height: 12),
        _buildPubMedField(),
      ],
    );
  }

  Widget _buildSummarizerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("OPERATIVE NOTES"),
        _buildTextArea("Paste lengthy surgical reports to condense..."),
        _buildDivider(),
        _buildSectionLabel("DOCUMENT UPLOAD"),
        _fileUploadCard("Upload Operative PDF", Icons.upload_file, ['pdf']),
      ],
    );
  }

  Widget _buildPredictorInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("DATASET UPLOAD"),
        _fileUploadCard("Select Clinical Dataset (CSV)", Icons.table_chart, ['csv', 'xlsx']),
        const SizedBox(height: 16),
        Text(
          "Accepted variables: Age, BMI, Bone Density, Comorbidities.",
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
        ),
      ],
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI DATA PORTAL", 
          style: TextStyle(color: widget.themeColors[0], fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        const Text(
          "Provide the necessary data below to initialize the RUSA 2.0 neural network.",
          style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _buildTextArea(String hint) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: TextField(
        controller: _textController,
        maxLines: 6,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24), border: InputBorder.none),
      ),
    );
  }

  Widget _fileUploadCard(String label, IconData icon, List<String> extensions) {
    bool isFileSelected = _selectedFileName != null;
    return InkWell(
      onTap: () => _pickFile(extensions),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.themeColors[0].withOpacity(isFileSelected ? 0.1 : 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isFileSelected ? Colors.green.withOpacity(0.4) : widget.themeColors[0].withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(isFileSelected ? Icons.check_circle : icon, color: isFileSelected ? Colors.green : widget.themeColors[0]),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                  if (isFileSelected)
                    Text(_selectedFileName!, style: const TextStyle(color: Colors.green, fontSize: 11), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPubMedField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          icon: Icon(Icons.link, color: Colors.white24, size: 18),
          hintText: "Enter PubMed ID or DOI URL",
          hintStyle: TextStyle(color: Colors.white24),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text("OR", style: TextStyle(color: Colors.white10, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processData,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.themeColors[0],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isProcessing 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("INITIALIZE ANALYSIS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }

  Widget _buildResultOutput() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [widget.themeColors[0].withOpacity(0.1), Colors.transparent]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.themeColors[0].withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: widget.themeColors[0], size: 16),
              const SizedBox(width: 8),
              const Text("MODEL OUTPUT", style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Text(_statusMessage!, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}