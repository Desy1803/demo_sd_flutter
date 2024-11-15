import 'package:flutter/material.dart';
import 'package:country_list_pick/country_list_pick.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username, _password, _firstName, _lastName, _email, _phoneNumber, _address, _city, _country;
  String? _phonePrefix; 
  DateTime? _birthday;


  Widget _buildTextField({
    required String label,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    Widget? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: inputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF001F3F)),
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF001F3F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF001F3F), width: 2),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final passwordRegEx = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$');
    if (!passwordRegEx.hasMatch(value)) {
      return 'Password must be at least 10 characters, include upper and lower case letters, numbers, and special characters';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegEx = RegExp(r'^\d{10}$');
    if (!phoneRegEx.hasMatch(value)) {
      return 'Phone number must be in the format +XX followed by 10 digits';
    }
    return null;
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      label: "Username",
      validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
      onSaved: (value) => _username = value,
      prefixIcon: const Icon(Icons.person, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      label: "Password",
      obscureText: true,
      validator: _validatePassword,
      onSaved: (value) => _password = value,
      prefixIcon: const Icon(Icons.lock, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildFirstNameField() {
    return _buildTextField(
      label: "First Name",
      validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
      onSaved: (value) => _firstName = value,
      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildLastNameField() {
    return _buildTextField(
      label: "Last Name",
      validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
      onSaved: (value) => _lastName = value,
      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      label: "Email",
      inputType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      onSaved: (value) => _email = value,
      prefixIcon: const Icon(Icons.email, color: Color(0xFF001F3F)),
    );
  }


Widget _buildCountryField() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 9.0),
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Color(0xFF001F3F), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flag_outlined, 
            color: const Color(0xFF001F3F) , 
            size: 24.0,           
          ),
          const SizedBox(width: 8), 
          const Text(
            "Country",
            style: TextStyle(
              color: Color(0xFF001F3F),
              fontSize: 16,
              fontWeight: FontWeight.normal,  
            ),
          ),
          const SizedBox(width: 16), 
          Expanded(
            child: CountryListPick(
              appBar: AppBar(
                backgroundColor: const Color(0xFF001F3F),
                title: const Text('Select Country'),
              ),
              initialSelection: '+1', 
              onChanged: (CountryCode? code) {
                setState(() {
                  _phonePrefix = code!.dialCode; 
                });
              },
            ),
          ),
        ],
      ),
    ),
  );
}






  Widget _buildAddressField() {
    return _buildTextField(
      label: "Address",
      validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
      onSaved: (value) => _address = value,
      prefixIcon: const Icon(Icons.home, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildCityField() {
    return _buildTextField(
      label: "City",
      validator: (value) => value == null || value.isEmpty ? 'City is required' : null,
      onSaved: (value) => _city = value,
      prefixIcon: const Icon(Icons.location_city, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
     padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
              label: "Phone Number",
              inputType: TextInputType.phone,
              validator: _validatePhoneNumber,
              onSaved: (value) => _phoneNumber = value,
              prefixIcon: const Icon(Icons.phone, color: Color(0xFF001F3F)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF001F3F),
        title: const Text(
          "Trading Reports",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create Your Account",
              style: TextStyle(
                color: Color(0xFF001F3F),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildUsernameField(),
            _buildPasswordField(),
            _buildFirstNameField(),
            _buildLastNameField(),
            _buildEmailField(),
            _buildPhoneNumberField(),
            _buildAddressField(),
            _buildCityField(),
            _buildCountryField(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState!.save();
                print('Username: $_username');
                print('Password: $_password');
                print('First Name: $_firstName');
                print('Last Name: $_lastName');
                print('Email: $_email');
                print('Phone Number: $_phonePrefix $_phoneNumber');
                print('Address: $_address');
                print('City: $_city');
                print('Country: $_country');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF001F3F),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Register",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
