# 📚 EduAI: AI-Powered Smart Learning Assistant  

**EduAI** is an intelligent **learning companion** that leverages **Machine Learning (ML) and Deep Learning (DL)** to provide a **personalized study experience, AI-driven tutoring, and productivity tracking**.  

🔍 **Project Type:** AI/ML-based Smart Learning App  
📌 **Status:** Active Development  
📊 **Tech Stack:** Flutter, Python (Flask, Pandas, Sklearn, TensorFlow), Firebase  

---

## 🚀 Overview  

EduAI adapts to the user's **learning preferences** and optimizes their study experience using:  
- **ML-based Learning Style Prediction**  
- **AI-powered Doubt Resolution with GPT-2**  
- **Personalized Course & Study Material Recommendations**  
- **Focus Mode for Time Tracking & Productivity Insights**  

---

## 🔬 Applied Machine Learning Models  

### ✅ **1. Learning Style Predictor**  
- **Model Used:** **Random Forest Classifier**  
- **Objective:** Categorizes users into one of four learning styles: **Visual, Auditory, Reading/Writing, Kinesthetic (VARK)**.  
- **Dataset:** User response dataset with learning behavior patterns.  
- **Results:** Achieved **95% accuracy** in learning style classification.  

---

### ✅ **2. Smart Recommendation System**  
- **Model Used:** **Hybrid Model (TF-IDF, SVD, Neural Networks)**  
- **Objective:** Suggests **courses & study materials** based on:  
  - Subject preferences  
  - Difficulty level  
  - Past interactions  
- **Implementation:** Combines **content-based filtering** and **collaborative filtering**.  


---

### ✅ **3. AI Tutor (Doubt Solver)**  
- **Model Used:** **Fine-tuned GPT-2 (PyTorch)**  
- **Objective:** Provides **instant doubt resolution, explanations, and interactive learning assistance**.  
- **Training Data:** SQuAD v2 dataset for Q&A fine-tuning.  
- **Implementation:**  
  - **Preprocessing:** Tokenized using GPT-2 tokenizer.  
  - **Fine-tuning:** PyTorch-based training on **Google Colab**.  
  - **Inference:** Deployed as a chatbot API.  
- **Results:** Generated **context-aware answers**.

---

### ✅ **4. Focus Mode & Productivity Tracker**  
- **Model Used:** **Logistic Regression & Time-Series Analysis**  
- **Objective:** Helps users track focused study time and analyze **productivity trends**.  
- **Implementation:**  
  - **Time tracking with user session data**  
  - **Prediction of optimal study duration**  
  - **Analysis of focus patterns**  


---

## 📊 Experiment Tracking  

| Model | Accuracy | Dataset Used | Key Features |  
|--------|---------|--------------|--------------|  
| Learning Style Predictor | 95% | Learning Behavior Dataset | Categorizes into VARK styles |  
| Recommendation System | | Course Interaction Data | Hybrid ML model for suggestions |  
| AI Tutor | | SQuAD v2 | Fine-tuned GPT-2 chatbot |  


---

## 📽️ Live Demo  

[![Watch the Demo](https://img.youtube.com/vi/mJapxqfsXks/0.jpg)](https://www.youtube.com/watch?v=mJapxqfsXks)  

Click the image above to watch EduAI in action!  

---

## 🛠 Tech Stack  

📌 **Frontend:** Flutter (Dart)  
📌 **Machine Learning & Backend:** Python, Flask, Pandas, Scikit-learn, TensorFlow, PyTorch  
📌 **API Integrations:**  
   - **YouTube API** (Educational Content)  
   - **Chatbot API** (AI Tutor)  
   - **Firebase** (Data Management & Authentication)  

---

## 📌 How to Run  

1️⃣ **Clone the repository:**  
```bash
git clone https://github.com/HarshiSharma04/EduAI.git

```

## Project Structure

- **Frontend**: Flutter web application (main directory)
- **Backend**: Python Flask API (`backend/` directory)

## Deployment to Vercel

### Frontend (Flutter Web)

1. **Install Flutter** (if not already installed):
   ```bash
   flutter doctor
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Build for web**:
   ```bash
   flutter build web --release
   ```

4. **Deploy to Vercel**:
   - Connect your GitHub repository to Vercel
   - Vercel will automatically detect the Flutter project and use the `vercel.json` configuration
   - The build command and output directory are already configured

### Backend (Python Flask)

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Deploy separately to Vercel**:
   - Create a new Vercel project for the backend
   - Point it to the `backend/` directory
   - Vercel will use the `backend/vercel.json` configuration

## Configuration

### Frontend Configuration
- `vercel.json`: Configures Flutter web build and routing
- `web/index.html`: Updated for better web compatibility
- Error handling added for network images

### Backend Configuration
- `backend/vercel.json`: Configures Python Flask deployment
- `backend/requirements.txt`: Python dependencies
- CORS enabled for cross-origin requests

## Features

- **Learning Style Assessment**: AI-powered learning style prediction
- **Interactive UI**: Modern Flutter-based interface
- **Responsive Design**: Works on web and mobile
- **API Integration**: Flask backend for ML predictions

## Development

### Running Locally

**Frontend**:
```bash
flutter run -d chrome
```

**Backend**:
```bash
cd backend
pip install -r requirements.txt
python app.py
```

## Notes

- The frontend and backend should be deployed as separate Vercel projects
- Update API endpoints in the Flutter app to point to your deployed backend URL
- Ensure all environment variables are properly set in Vercel
