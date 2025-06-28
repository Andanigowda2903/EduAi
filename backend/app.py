from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the dataset
try:
    df = pd.read_csv('learning_styles.csv')
    
    # Preprocess data and train the model
    X = df.drop('LearningStyle', axis=1)
    y = df['LearningStyle']

    model = RandomForestClassifier(random_state=42)
    model.fit(X, y)
except Exception as e:
    print(f"Error loading model: {e}")
    model = None

@app.route('/')
def home():
    return jsonify({'message': 'EduAI Backend API is running!'})

@app.route('/predictLearningStyle', methods=['POST'])
def predict_learning_style():
    if model is None:
        return jsonify({'error': 'Model not loaded'}), 500
    
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400

        # Example data received from Flutter app
        question_data = pd.DataFrame(data, index=[0])

        # Make prediction
        prediction = model.predict(question_data)

        # Respond with predicted learning style
        return jsonify({'learningStyle': prediction[0]})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy', 'model_loaded': model is not None})

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
