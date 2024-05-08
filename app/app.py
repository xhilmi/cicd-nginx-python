from flask import Flask, jsonify, request, send_from_directory

app = Flask(__name__)

@app.route('/', methods=["GET"])
def hello_world():
    return jsonify({'ip': request.environ.get('HTTP_X_FORWARDED_FOR', request.remote_addr),
                    'methods': 'GET',
                    'headers': str(request.headers)}), 200

@app.route('/postdata', methods=["POST"])
def handle_post():
    data = request.json
    return jsonify({'message': 'Data received', 'yourData': data}), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Resource not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == "__main__":
    app.run(debug=True)
