import '../user_model.dart';

final kMockUser = UserModel(
  id: 1,
  name: 'Jean-Marie Ondo',
  email: 'jean@gmail.com',
  phone: '+24107000000',
  plan: 'kevazingo',
  isVerified: true,
  createdAt: DateTime(2026, 1, 7),
);

const kMockToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.mock_token';
