#!flask/bin/python
from flask import Flask, jsonify, request
import csv

app = Flask(__name__)

with open('tasks.csv', 'r') as input_file:
        reader = csv.DictReader(input_file)
        tasks = [r for r in reader]

#Get request
@app.route('/api/v1.0/tasks', methods=['GET'])
def get_tasks():
    with open('tasks.csv', 'r') as input_file:
        reader = csv.DictReader(input_file)
        tasks = [r for r in reader]
    return jsonify({'tasks': tasks})

#Post request
@app.route('/api/v1.0/tasks', methods=['POST'])
def create_task():
    if not request.json and not 'title' in request.json and not 'description' in request.json:
        abort(400)
    task = {
        'title': request.json['title'],
        'description': request.json.get('description', ""),
    }
    tasks.append(task)
    keys = tasks[0].keys()
    with open('tasks.csv', 'wb') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(tasks)
    return jsonify({'task': task}), 201

@app.route('/healthcheck', methods=['GET'])
def get_healthcheck():
    return str(200)


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

