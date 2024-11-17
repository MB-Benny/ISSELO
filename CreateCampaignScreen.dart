import 'dart:convert'; // Required for jsonEncode

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/CampaignRepository.dart';
import '../../logic/bloc/campaign_bloc.dart';
import '../../logic/bloc/campaign_event.dart';
import '../../logic/bloc/campaign_state.dart';
import 'CampaignStepScreen.dart';

class CreateCampaignScreen extends StatefulWidget {
  @override
  _CreateCampaignScreenState createState() => _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends State<CreateCampaignScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _previewController = TextEditingController();
  final TextEditingController _fromNameController = TextEditingController();
  final TextEditingController _fromEmailController = TextEditingController();

  bool runOncePerCustomer = true;
  bool customAudience = false;

  late CampaignBloc campaignBloc;

  @override
  void initState() {
    super.initState();
    campaignBloc = CampaignBloc(CampaignRepository());
    campaignBloc.add(LoadDraftEvent());
  }

  // Email validator function using regular expression
  String? emailValidator(String? value) {
    const emailRegex = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    final emailTest = RegExp(emailRegex);

    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!emailTest.hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => campaignBloc,
      child: BlocListener<CampaignBloc, CampaignState>(
        listener: (context, state) {
          if (state is CampaignLoadedState) {
            _subjectController.text = state.draftData["subject"] ?? "";
            _previewController.text = state.draftData["previewText"] ?? "";
            _fromNameController.text = state.draftData["fromName"] ?? "";
            _fromEmailController.text = state.draftData["fromEmail"] ?? "";
          } else if (state is CampaignSavedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Draft saved successfully!")),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Container(
                  width: 579,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Centered Text Section
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Create New Email Campaign',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Fill out these details to build your broadcast',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          "Campaign Subject",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            hintText: "Enter Subject",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "Subject is required" : null,
                        ),
                        const SizedBox(height: 16),

                        const Text(
                          "Preview Text",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _previewController,
                          decoration: InputDecoration(
                            hintText: "Enter text here...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                          maxLines: 3,
                          maxLengthEnforcement: MaxLengthEnforcement.none,
                          validator: (value) => value!.isEmpty
                              ? "Preview text is required"
                              : null,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Keep this simple and within 50 characters.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '"From" Name',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _fromNameController,
                                    decoration: InputDecoration(
                                      hintText: "From Anne",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.orange),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.orange),
                                      ),
                                    ),
                                    validator: (value) =>
                                    value!.isEmpty ? '"From" Name is required' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '"From" Email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _fromEmailController,
                                    decoration: InputDecoration(
                                      hintText: "Anne@example.com",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.orange),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        borderSide: BorderSide(color: Colors.orange),
                                      ),
                                    ),
                                    validator: emailValidator, // Custom email validator
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(thickness: 0.05,),
                        const SizedBox(height: 10),

                        SwitchListTile(
                          value: runOncePerCustomer,
                          onChanged: (value) {
                            setState(() {
                              runOncePerCustomer = value;
                            });
                          },
                          activeColor: Colors.orange,
                          title: const Text(
                            'Run only once per customer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),

                        SwitchListTile(
                          value: customAudience,
                          onChanged: (value) {
                            setState(() {
                              customAudience = value;
                            });
                          },
                          activeColor: Colors.orange,
                          title: const Text('Custom audience'),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 16),

                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            children: [
                              const TextSpan(text: 'You can set up a '),
                              TextSpan(
                                text: 'custom domain or connect your email service provider',
                                style: TextStyle(color: Colors.red[800]),
                              ),
                              const TextSpan(text: ' to change this.'),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  final draftData = {
                                    "subject": _subjectController.text,
                                    "previewText": _previewController.text,
                                    "fromName": _fromNameController.text,
                                    "fromEmail": _fromEmailController.text,
                                  };
                                  campaignBloc.add(SaveDraftEvent(draftData));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  "Save Draft",
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final formData = {
                                      "subject": _subjectController.text,
                                      "previewText": _previewController.text,
                                      "fromName": _fromNameController.text,
                                      "fromEmail": _fromEmailController.text,
                                      "runOncePerCustomer": runOncePerCustomer,
                                      "customAudience": customAudience,
                                    };

                                    // Convert form data to JSON format and print it
                                    String jsonData = jsonEncode(formData);
                                    print("Form Data in JSON Format: $jsonData");

                                    campaignBloc.add(ValidateFormEvent(true));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CampaignStepScreen(),
                                      ),
                                    );
                                  } else {
                                    campaignBloc.add(ValidateFormEvent(false));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: const Text(
                                  "Next Step",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
