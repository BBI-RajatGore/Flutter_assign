import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// This annotation tells the code generator to generate a mock class for `http.Client`
@GenerateMocks([http.Client])
void main() {}
