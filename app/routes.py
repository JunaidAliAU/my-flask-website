from flask import Blueprint, render_template

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    return render_template('index.html')

@main_bp.route('/about')
def about():
    return render_template('index.html', section='about')

@main_bp.route('/api/hello')
def hello_api():
    return {"message": "Hello from Flask API!"}