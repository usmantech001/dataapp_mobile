import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../core/enum.dart';
import 'custom_components/custom_input_field.dart';
import 'custom_components/loading.dart';
import 'custom_snackbar.dart';
import 'image_manager/image_manager.dart';
import 'style_manager/styles_manager.dart';


class SelectFromContactWidget extends StatefulWidget {
  
 const SelectFromContactWidget({
    super.key,
  });

  @override
  State<SelectFromContactWidget> createState() => _SelectFromContactWidgetState();
}

class _SelectFromContactWidgetState extends State<SelectFromContactWidget> {
  bool _loading = true;
  dynamic _error = null;
  final searchParam = TextEditingController();
  List<Contact> _contacts = [];
  void _loadCountries() async {
    
    if (await FlutterContacts.requestPermission()) {
      setState(() => _loading = true);
      FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false, 
        withThumbnail: false
      ).then((value) {
        _contacts = value;
        _contacts.forEach((element) {
          print(element.toJson());
        });
        setState(() => _loading = false);
      }).catchError((error) {
        showCustomToast(context: context, description: "${error}", type: ToastType.error);
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    _loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: Colors.white
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Select contact", style: get14TextStyle().copyWith(
            color: Color(0x001C1C1C).withOpacity(.8),
          ),),

          const SizedBox(height: 14,),

          CustomInputField(
            hintText: "Search Contact",
            textEditingController: searchParam,
            onChanged: (v) {
              setState(() { });
            } ,
          ),

          const SizedBox(height: 25,),

          Expanded(
            child: Builder(
              builder: (context) {
                final contacts = _contacts.where((element) 
                  => 
                    element.displayName.toLowerCase().contains(searchParam.text.toLowerCase()) 
                    && element.phones.length > 0).toList();
                if (_loading) {
                  return buildLoading();
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(height: 1, color: Color(0xFFE9E9E9).withOpacity(.49),),
                    itemCount: contacts.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, contact);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Expanded(child: Text("${contact.displayName}")),
                              // Image.asset(ImageManager.kArrowForward, height: 14, width: 14,)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            ),
          )

        ],
      ),
    );
  }
}