import unittest
from app import app

class TestFlaskApp(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_health_endpoint(self):
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        data = response.get_json()
        self.assertEqual(data['status'], 'healthy')

    def test_status_endpoint(self):
        response = self.app.get('/api/v1/status')
        self.assertEqual(response.status_code, 200)

if __name__ == '__main__':
    unittest.main()
