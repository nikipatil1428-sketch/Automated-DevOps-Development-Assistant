import pytest
import os
from app.app import app   # Make sure your folder structure supports this

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home_page(client):
    response = client.get('/')
    assert response.status_code == 200
    assert 'DevOps Assistant' in response.json['message']

def test_health_check(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json['status'] == 'healthy'

def test_version_env(client):
    os.environ['VERSION'] = '2.0.0'   # set env variable
    response = client.get('/')
    assert response.status_code == 200
    assert 'version' in response.json
    assert response.json['version'] == '2.0.0'