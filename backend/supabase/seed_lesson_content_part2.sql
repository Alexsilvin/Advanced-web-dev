-- ============================================================
--  EduSkills — Lesson Notes & Exercises  (Part 2)
-- ============================================================
--  Covers:
--    • Data Science lessons 9–16
--    • Software Architecture & Design Patterns (all 13)
--    • Software Verification & Validation (all 13)
--    • Advanced Database Systems (all 15)
-- ============================================================

BEGIN;

-- ============================================================
--  DATA SCIENCE — lessons 9–16  (appended to existing array)
-- ============================================================
-- Replaces the FULL lessons array so lessons 1-8 (from part 1)
-- must already be present OR you re-run part 1 first.
-- If you want a safe idempotent approach, run part 1 then part 2.

UPDATE courses SET lessons = (
  SELECT lessons || $ds_extra$
  [
    {
      "title": "Neural Networks from Scratch: Backpropagation & Gradient Descent in NumPy",
      "duration": "95 min", "videoUrl": "",
      "description": "Build a multilayer perceptron without a framework to truly understand training.",
      "notes": {
        "overview": "A neural network is a composition of linear transformations (weight matrices) and non-linear activations. Forward propagation computes a prediction; backpropagation uses the chain rule to compute the gradient of the loss with respect to every parameter. Implementing this in NumPy — without autograd — forces full understanding of what frameworks hide.",
        "keyPoints": [
          "Forward pass: Z = X·W + b, A = activation(Z), repeated per layer",
          "Loss function quantifies prediction error: MSE for regression, cross-entropy for classification",
          "Backprop applies chain rule: dL/dW = dL/dA · dA/dZ · dZ/dW, computed layer-by-layer from output to input",
          "Gradient descent update: W = W - α·dL/dW where α is the learning rate",
          "Vanishing gradients occur in deep sigmoid/tanh networks — ReLU (max(0,x)) alleviates this with a constant gradient for positive inputs"
        ],
        "codeExample": "import numpy as np\n\ndef relu(z): return np.maximum(0, z)\ndef relu_prime(z): return (z > 0).astype(float)\n\n# One forward + backward step\nZ1 = X @ W1 + b1\nA1 = relu(Z1)\nZ2 = A1 @ W2 + b2  # output layer (linear for regression)\nloss = np.mean((Z2 - y) ** 2)  # MSE\n\n# Backprop\ndZ2 = 2 * (Z2 - y) / len(y)\ndW2 = A1.T @ dZ2\ndA1 = dZ2 @ W2.T\ndZ1 = dA1 * relu_prime(Z1)\ndW1 = X.T @ dZ1\n\n# Update\nW2 -= lr * dW2\nW1 -= lr * dW1",
        "deepDive": "The learning rate α is the single most sensitive hyperparameter. Too large: loss diverges or oscillates. Too small: training takes thousands of epochs. Learning rate schedulers (cosine annealing, reduce-on-plateau) and adaptive optimisers (Adam, which maintains per-parameter adaptive learning rates) solve this in practice.",
        "summary": "Implementing backpropagation by hand is the most valuable exercise in deep learning — every framework behaviour makes sense once you have done it once."
      },
      "exercise": {
        "title": "Quiz: Neural Networks & Backpropagation",
        "timeLimit": 19,
        "questions": [
          {
            "id": 1,
            "question": "What is the purpose of the activation function in a neural network?",
            "options": ["To normalise the input data", "To introduce non-linearity so the network can learn complex functions beyond linear mappings", "To initialise the weight matrices", "To compute the loss"],
            "correct": 1,
            "explanation": "Without non-linear activations, stacking linear layers still produces a linear transformation (composition of linear maps is linear). Activations like ReLU and sigmoid allow networks to approximate arbitrary functions."
          },
          {
            "id": 2,
            "question": "What problem does ReLU solve compared to sigmoid in deep networks?",
            "options": ["ReLU is faster to compute", "ReLU prevents the vanishing gradient problem because its gradient is 1 for positive inputs, not squeezed near zero", "ReLU outputs probabilities between 0 and 1", "ReLU requires no backpropagation"],
            "correct": 1,
            "explanation": "Sigmoid saturates (gradient ≈ 0) for large positive or negative inputs, causing gradients to vanish in early layers during backprop. ReLU has gradient = 1 for all positive inputs, allowing gradients to flow freely."
          },
          {
            "id": 3,
            "question": "In gradient descent, what does the learning rate α control?",
            "options": ["The number of training epochs", "The size of each parameter update step along the gradient direction", "The number of hidden layers", "The batch size used during training"],
            "correct": 1,
            "explanation": "α scales the gradient before subtracting from weights: W = W - α·∇L. Too large causes overshooting; too small causes slow convergence. Adaptive optimisers like Adam adjust α per-parameter automatically."
          }
        ]
      }
    },
    {
      "title": "Deep Learning with TensorFlow & Keras: CNNs for Vision & RNNs for Sequences",
      "duration": "100 min", "videoUrl": "",
      "description": "Build, train, and evaluate convolutional and recurrent networks.",
      "notes": {
        "overview": "TensorFlow 2.x uses Keras as its primary API. The Sequential API stacks layers linearly; the Functional API handles branching architectures. Convolutional Neural Networks (CNNs) learn spatial feature hierarchies in images via convolution kernels; Recurrent Neural Networks (RNNs) and LSTMs process sequential data with memory across time steps.",
        "keyPoints": [
          "A Conv2D layer applies learnable filters across the input image — shallow layers detect edges, deeper layers detect objects",
          "MaxPooling downsamples feature maps, reducing computation and providing translation invariance",
          "Transfer learning (using a pre-trained backbone like MobileNetV3) achieves high accuracy with 100× less training data",
          "LSTMs solve the vanishing gradient problem in RNNs via gates (forget, input, output) that control information flow across time steps",
          "Dropout (randomly zeroing neurons during training) is the most effective regularisation technique for neural networks"
        ],
        "codeExample": "import tensorflow as tf\nfrom tensorflow.keras import layers, Model\n\n# Transfer learning with MobileNetV3\nbase = tf.keras.applications.MobileNetV3Small(include_top=False, weights='imagenet')\nbase.trainable = False\n\ninputs = tf.keras.Input(shape=(224, 224, 3))\nx = base(inputs, training=False)\nx = layers.GlobalAveragePooling2D()(x)\nx = layers.Dropout(0.2)(x)\noutputs = layers.Dense(5, activation='softmax')(x)\nmodel = Model(inputs, outputs)\n\nmodel.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])\nmodel.fit(train_ds, validation_data=val_ds, epochs=20)",
        "deepDive": "Fine-tuning a pre-trained model (unfreezing the top layers of the backbone and training at a very low learning rate, e.g. 1e-5) almost always improves on frozen-backbone transfer learning. Unfreeze only after the new head has converged — otherwise the randomly initialised head will destroy the pre-trained weights with large gradient updates.",
        "summary": "Transfer learning collapses the data and compute requirements of deep learning to something achievable on a laptop for most domain-specific classification tasks."
      },
      "exercise": {
        "title": "Quiz: Deep Learning with TensorFlow & Keras",
        "timeLimit": 20,
        "questions": [
          {
            "id": 1,
            "question": "What does a Conv2D layer actually learn?",
            "options": ["The pixel values of the input image", "A set of learnable filter kernels that detect spatial features like edges, textures, and patterns", "The class labels of the training set", "Statistical normalisation parameters"],
            "correct": 1,
            "explanation": "Convolutional filters are the learnable parameters of a Conv2D layer. Each filter slides over the input and activates when it detects its learned pattern. Early layers detect low-level features (edges); later layers combine these into complex features (faces, objects)."
          },
          {
            "id": 2,
            "question": "Why is base.trainable = False used in the transfer learning example?",
            "options": ["To speed up inference", "To freeze the pre-trained weights so the backbone's learned ImageNet features are preserved while only the new head trains", "To prevent overfitting in the base model", "To reduce the model's memory footprint"],
            "correct": 1,
            "explanation": "Setting trainable=False freezes all weights in the base model. This prevents the ImageNet features from being overwritten by gradients from the new (randomly initialised) head, which would be destructive to the pre-trained representations."
          },
          {
            "id": 3,
            "question": "What problem do LSTMs solve compared to vanilla RNNs?",
            "options": ["LSTMs process data faster than RNNs", "LSTMs use gating mechanisms to preserve long-range dependencies, preventing vanishing gradients over many time steps", "LSTMs require less training data", "LSTMs can process images, unlike RNNs"],
            "correct": 1,
            "explanation": "Vanilla RNNs suffer from vanishing gradients over long sequences — information from early time steps is lost. LSTM's forget, input, and output gates create a highway for gradients to flow across hundreds of time steps without vanishing."
          }
        ]
      }
    },
    {
      "title": "NLP: Text Preprocessing, TF-IDF, Word2Vec & BERT Fine-Tuning",
      "duration": "95 min", "videoUrl": "",
      "description": "Classify sentiment and fine-tune a Transformer on African news data.",
      "notes": {
        "overview": "Natural Language Processing transforms unstructured text into numerical representations models can learn from. The progression from bag-of-words → TF-IDF → Word2Vec → Transformers (BERT) reflects increasing ability to capture context and semantics. Modern NLP is dominated by pre-trained large language models fine-tuned on task-specific data.",
        "keyPoints": [
          "TF-IDF weights terms by frequency in a document (TF) times rarity across the corpus (IDF) — common words like 'the' get near-zero weight",
          "Word2Vec produces dense vector embeddings where semantically similar words have high cosine similarity — king - man + woman ≈ queen",
          "BERT (Bidirectional Encoder Representations from Transformers) reads text in both directions simultaneously, capturing full context",
          "Fine-tuning adds a task-specific head (classification layer) to a pre-trained BERT and trains on labelled examples at a low learning rate (2e-5)",
          "Tokenisation splits text into subword units (WordPiece/BPE) — unknown words are broken into known subword pieces, eliminating out-of-vocabulary issues"
        ],
        "codeExample": "from transformers import AutoTokenizer, AutoModelForSequenceClassification, Trainer, TrainingArguments\n\nmodel_name = 'bert-base-multilingual-cased'\ntokenizer = AutoTokenizer.from_pretrained(model_name)\nmodel = AutoModelForSequenceClassification.from_pretrained(model_name, num_labels=3)\n\ndef tokenize(batch):\n    return tokenizer(batch['text'], padding=True, truncation=True, max_length=128)\n\ntraining_args = TrainingArguments(\n    output_dir='./results',\n    num_train_epochs=3,\n    learning_rate=2e-5,\n    per_device_train_batch_size=16\n)\ntrainer = Trainer(model=model, args=training_args, train_dataset=train_ds)\ntrainer.train()",
        "deepDive": "Multilingual BERT (mBERT) is pre-trained on 104 languages and performs surprisingly well on low-resource African languages (Swahili, Hausa, Yoruba) even without language-specific fine-tuning. For better results, language-specific models like AfroXLMR or Afro-XLMR-base are available and provide significant performance gains on African language NLP tasks.",
        "summary": "Fine-tuning BERT achieves state-of-the-art text classification with fewer than 1000 labelled examples — a transformative capability for resource-limited applications."
      },
      "exercise": {
        "title": "Quiz: NLP & Transformers",
        "timeLimit": 19,
        "questions": [
          {
            "id": 1,
            "question": "What is the difference between TF and IDF in TF-IDF?",
            "options": [
              "TF measures sentence length; IDF measures word frequency",
              "TF (Term Frequency) measures how often a term appears in a document; IDF (Inverse Document Frequency) measures how rare the term is across all documents",
              "TF measures token count; IDF measures character count",
              "TF is used for training; IDF is used for inference"
            ],
            "correct": 1,
            "explanation": "TF-IDF = TF × IDF. High TF means the word appears often in this document (relevant). High IDF means it appears in few documents overall (distinctive). The product gives high weight to words that are frequent in one document but rare elsewhere."
          },
          {
            "id": 2,
            "question": "What makes BERT 'bidirectional' compared to earlier models like GPT?",
            "options": [
              "BERT processes text from right to left",
              "BERT's attention layers see all tokens simultaneously (both left and right context) when encoding each token",
              "BERT uses two separate RNNs in opposite directions",
              "BERT processes both the question and answer simultaneously"
            ],
            "correct": 1,
            "explanation": "GPT-style models are autoregressive — each token only attends to previous tokens. BERT uses masked language modelling: it masks 15% of tokens and predicts them using full bidirectional context (all surrounding tokens), learning richer contextual representations."
          },
          {
            "id": 3,
            "question": "Why is the learning rate set very low (e.g. 2e-5) when fine-tuning BERT?",
            "options": [
              "BERT is computationally expensive so we need fewer gradient steps",
              "Large learning rates would overwrite the pre-trained weights with noise from the small fine-tuning dataset, destroying the learned representations",
              "BERT's architecture requires a specific learning rate for mathematical stability",
              "Low learning rates prevent overfitting on small datasets"
            ],
            "correct": 1,
            "explanation": "The pre-trained weights encode rich linguistic knowledge. A large learning rate would cause catastrophic forgetting — overwriting these representations with gradient noise from a few thousand examples. A small rate (1e-5 to 5e-5) makes tiny adjustments that adapt the model to the task."
          }
        ]
      }
    },
    {
      "title": "Computer Vision: Object Detection with YOLOv8",
      "duration": "85 min", "videoUrl": "",
      "description": "Train a detection model to identify crop disease from drone imagery.",
      "notes": {
        "overview": "Object detection solves two problems simultaneously: 'what is in the image?' (classification) and 'where is it?' (localisation with bounding boxes). YOLO (You Only Look Once) achieves real-time detection by treating detection as a single regression problem, predicting bounding boxes and class probabilities from the full image in one pass.",
        "keyPoints": [
          "Two-stage detectors (Faster R-CNN): slow but accurate — first propose regions, then classify each region",
          "Single-stage detectors (YOLO, SSD): fast and accurate — predict boxes and classes directly without a separate proposal step",
          "IoU (Intersection over Union) measures bounding box overlap — IoU > 0.5 is typically considered a correct detection",
          "Non-Maximum Suppression (NMS) removes duplicate detections for the same object by keeping only the box with the highest confidence",
          "Data augmentation (flips, rotations, colour jitter, mosaic) is critical for detection — more so than classification because annotations must transform with the image"
        ],
        "codeExample": "from ultralytics import YOLO\n\n# Load a pre-trained YOLOv8 model\nmodel = YOLO('yolov8n.pt')  # nano — fastest\n\n# Fine-tune on custom crop disease dataset\nresults = model.train(\n    data='crop_disease.yaml',  # path to dataset config\n    epochs=50,\n    imgsz=640,\n    batch=16,\n    patience=10,  # early stopping\n    augment=True\n)\n\n# Inference on new image\nresults = model.predict('field_photo.jpg', conf=0.4, iou=0.5)\nresults[0].show()  # display bounding boxes",
        "deepDive": "Annotation quality is the bottleneck in production computer vision, not model architecture. A YOLOv8 model trained on 500 carefully annotated images will outperform one trained on 5000 noisily labelled images. Tools like Roboflow and CVAT make annotation collaborative; active learning prioritises the most informative images for human review.",
        "summary": "YOLOv8 fine-tuning on 200–500 domain-specific images can achieve production-ready object detection for specialised use cases like plant disease or infrastructure inspection."
      },
      "exercise": {
        "title": "Quiz: Object Detection",
        "timeLimit": 17,
        "questions": [
          {
            "id": 1,
            "question": "What does IoU (Intersection over Union) measure in object detection?",
            "options": [
              "The confidence score of a detection",
              "The overlap between the predicted bounding box and the ground-truth box — values closer to 1 indicate better localisation",
              "The number of objects detected per image",
              "The ratio of true positives to false positives"
            ],
            "correct": 1,
            "explanation": "IoU = area of overlap / area of union between predicted and ground-truth boxes. IoU = 1.0 means perfect overlap; 0 means no overlap. A common detection threshold is IoU > 0.5 to count a detection as a true positive."
          },
          {
            "id": 2,
            "question": "What is the purpose of Non-Maximum Suppression (NMS)?",
            "options": [
              "To remove low-confidence detections below a threshold",
              "To eliminate duplicate bounding boxes for the same object, keeping only the highest-confidence prediction",
              "To resize bounding boxes to a standard size",
              "To convert bounding box coordinates from relative to absolute"
            ],
            "correct": 1,
            "explanation": "YOLO predicts many overlapping boxes for the same object. NMS iteratively keeps the box with the highest confidence, removes all boxes that have IoU > threshold with it, and repeats — leaving one box per object."
          },
          {
            "id": 3,
            "question": "Why is data augmentation more complex for object detection than for image classification?",
            "options": [
              "Detection models are bigger and need more augmentation",
              "Bounding box coordinates must be transformed consistently with every spatial augmentation applied to the image",
              "Detection datasets are always smaller than classification datasets",
              "Augmentation is not beneficial for object detection"
            ],
            "correct": 1,
            "explanation": "When you flip, rotate, or crop an image for classification, only the image changes. For detection, every bounding box annotation must be transformed with the same operation — a flipped image needs horizontally mirrored boxes. This coordinate tracking is non-trivial."
          }
        ]
      }
    },
    {
      "title": "Model Deployment: FastAPI + Docker + Cloud Deploy on Render",
      "duration": "80 min", "videoUrl": "",
      "description": "Wrap your trained model in a production API with async inference.",
      "notes": {
        "overview": "A trained model is worthless until other systems can use its predictions. Deployment means wrapping the model in an API service that accepts inputs, returns predictions, and handles errors gracefully. FastAPI is the standard choice for Python ML APIs: it is async-capable, auto-generates OpenAPI docs, and validates inputs via Pydantic.",
        "keyPoints": [
          "Save models with model.save() (TF/Keras), joblib.dump() (sklearn), or model.save_pretrained() (HuggingFace) for serialisation",
          "Pydantic models in FastAPI provide automatic input validation with descriptive error messages — invalid payloads never reach model inference",
          "Async inference (async def predict) allows FastAPI to handle concurrent requests without blocking on slow model computation",
          "Model warm-up on startup (loading weights into memory) prevents the first request from timing out due to cold-start latency",
          "Containerise with Docker to ensure the production environment exactly matches development — include Python version, CUDA version, and system libraries"
        ],
        "codeExample": "from fastapi import FastAPI\nfrom pydantic import BaseModel\nimport joblib, numpy as np\n\napp = FastAPI(title='Crop Yield Predictor')\n\n# Load on startup\n@app.on_event('startup')\nasync def load_model():\n    app.state.model = joblib.load('model.pkl')\n    app.state.scaler = joblib.load('scaler.pkl')\n\nclass PredictRequest(BaseModel):\n    rainfall_mm: float\n    temperature_c: float\n    soil_ph: float\n\n@app.post('/predict')\nasync def predict(req: PredictRequest):\n    X = np.array([[req.rainfall_mm, req.temperature_c, req.soil_ph]])\n    X_scaled = app.state.scaler.transform(X)\n    prediction = float(app.state.model.predict(X_scaled)[0])\n    return { 'predicted_yield_tonnes_per_ha': round(prediction, 2) }",
        "deepDive": "In production, model inference latency under load is the main challenge. Strategies: (1) batch incoming requests and process them together (2-5× throughput gain), (2) use ONNX runtime instead of the native framework for faster CPU inference, (3) cache predictions for repeated identical inputs. For high-throughput scenarios, consider Triton Inference Server.",
        "summary": "A FastAPI service with Pydantic validation, startup model loading, and Docker packaging is the minimum viable architecture for a production ML endpoint."
      },
      "exercise": {
        "title": "Quiz: ML Model Deployment",
        "timeLimit": 16,
        "questions": [
          {
            "id": 1,
            "question": "Why should a model be loaded during FastAPI startup rather than per-request?",
            "options": [
              "FastAPI does not support per-request file loading",
              "Loading gigabyte-scale model weights per request would make the API 100× slower and exhaust memory",
              "The model file would be locked by the OS during loading",
              "Startup loading enables GPU acceleration"
            ],
            "correct": 1,
            "explanation": "Loading model weights from disk takes 1–30 seconds. Doing this on every request makes the API unusably slow. Load once at startup into app.state (or a global) and reuse the in-memory model for every request."
          },
          {
            "id": 2,
            "question": "What does Pydantic validation in FastAPI provide?",
            "options": [
              "Automatic model training based on input data",
              "Automatic type coercion and validation of request bodies — invalid inputs return a 422 error before reaching model code",
              "SQL query generation from request parameters",
              "JWT authentication for endpoints"
            ],
            "correct": 1,
            "explanation": "Pydantic BaseModel defines the expected types and constraints. FastAPI validates every incoming request against the model — missing fields or wrong types return a descriptive 422 Unprocessable Entity response automatically, before model inference runs."
          },
          {
            "id": 3,
            "question": "What is the primary benefit of containerising an ML model with Docker?",
            "options": [
              "Docker automatically accelerates model inference",
              "The exact Python version, library versions, and system dependencies are frozen, eliminating 'works on my machine' deployment failures",
              "Docker provides GPU support automatically",
              "Docker compresses the model weights to reduce storage"
            ],
            "correct": 1,
            "explanation": "ML models are highly sensitive to library versions — a different numpy or scikit-learn version can change predictions or cause errors. Docker captures the complete environment (Python, packages, OS libraries) as a reproducible image."
          }
        ]
      }
    },
    {
      "title": "Big Data with Apache Spark & PySpark",
      "duration": "90 min", "videoUrl": "",
      "description": "Process datasets that do not fit in memory with distributed computation.",
      "notes": {
        "overview": "Apache Spark is a distributed computing engine that processes data across a cluster of machines. PySpark is the Python API. Unlike pandas (which loads data into one machine's RAM), Spark partitions data across nodes and executes operations lazily — building a DAG of transformations that is only executed when an action (count, collect, write) is called.",
        "keyPoints": [
          "Spark DataFrames have the same API as pandas but execute distributed — transformations are lazy, actions trigger execution",
          "The DAG (Directed Acyclic Graph) optimiser (Catalyst) rewrites query plans for efficiency before execution",
          "Partitioning determines parallelism — too few partitions underutilise the cluster; too many creates scheduling overhead",
          "Avoid collect() on large datasets — it pulls all data to the driver node, defeating distributed processing",
          "Spark MLlib provides scalable ML algorithms (LogisticRegression, RandomForest, ALS) that run distributed across the cluster"
        ],
        "codeExample": "from pyspark.sql import SparkSession\nfrom pyspark.sql import functions as F\n\nspark = SparkSession.builder.appName('EduAnalytics').getOrCreate()\n\n# Read 10 GB CSV across 100 partitions\ndf = spark.read.csv('gs://bucket/enrollments/*.csv', header=True, inferSchema=True)\n\n# Lazy transformation — no computation yet\nresult = (df\n  .filter(F.col('progress') > 50)\n  .groupBy('category')\n  .agg(F.avg('progress').alias('avg_progress'),\n       F.count('*').alias('enrolled'))\n  .orderBy('avg_progress', ascending=False)\n)\n\nresult.show()  # action — triggers execution",
        "deepDive": "The biggest performance bottleneck in Spark is a shuffle — data redistribution across nodes during groupBy, join, or distinct operations. Each shuffle requires writing data to disk and transferring it over the network. Minimise shuffles by broadcasting small tables (spark.broadcast()), partitioning data by the join key in advance, and filtering early to reduce data volume before shuffling.",
        "summary": "Spark lets a single Python script process terabytes of data across a cluster — the same PySpark code that runs locally on a sample will scale to a 100-node cluster without modification."
      },
      "exercise": {
        "title": "Quiz: Apache Spark & PySpark",
        "timeLimit": 18,
        "questions": [
          {
            "id": 1,
            "question": "What is lazy evaluation in Spark?",
            "options": [
              "Spark processes data more slowly than pandas",
              "Transformations build a logical plan but do not execute until an action is called — allowing Catalyst to optimise the full plan first",
              "Spark delays loading data until disk space is available",
              "Spark defers writing results until the application exits"
            ],
            "correct": 1,
            "explanation": "Spark transformations (filter, groupBy, select) record operations in a DAG without executing. When an action (show, count, write) is called, Catalyst optimises the full DAG and Spark executes the minimum work needed — often combining multiple steps into single stage passes."
          },
          {
            "id": 2,
            "question": "Why should you avoid calling .collect() on a large Spark DataFrame?",
            "options": [
              "collect() is slower than show()",
              "collect() pulls all distributed data to the driver node's memory — a 1 TB DataFrame would crash a machine with 16 GB RAM",
              "collect() triggers extra network shuffles",
              "collect() does not work with DataFrames, only RDDs"
            ],
            "correct": 1,
            "explanation": "collect() retrieves every row from all worker nodes to the driver. On a large dataset this overflows driver memory and kills the application. Use show(n) to preview, write to storage for full output, or aggregate first then collect the small result."
          },
          {
            "id": 3,
            "question": "What is a Spark shuffle and why is it expensive?",
            "options": [
              "A shuffle randomises the order of rows for model training",
              "A shuffle redistributes rows across partitions/nodes by a key — it requires disk I/O and network transfer, making it the most expensive Spark operation",
              "A shuffle rebalances the number of partitions for better parallelism",
              "A shuffle is Spark's term for joining two DataFrames"
            ],
            "correct": 1,
            "explanation": "Operations like groupBy and join require all rows with the same key to be on the same node. Spark writes current partition data to disk, transfers it across the network, and reads it on the destination node. This disk I/O + network transfer is 10–100× slower than in-memory operations."
          }
        ]
      }
    },
    {
      "title": "MLOps: Experiment Tracking with MLflow & Model Monitoring",
      "duration": "75 min", "videoUrl": "",
      "description": "Set up reproducible ML workflows and detect model drift in production.",
      "notes": {
        "overview": "MLOps applies DevOps principles to machine learning: automation, versioning, monitoring, and reproducibility. Without MLOps, data science teams frequently cannot reproduce results from 3 months ago, do not know when production model performance degraded, and manually deploy models through error-prone processes. MLflow solves experiment tracking; dedicated monitoring tools detect drift.",
        "keyPoints": [
          "MLflow tracks every experiment run: parameters, metrics, artifacts (models, plots) — enabling reproducibility and comparison",
          "Model Registry provides lifecycle management: models move from Staging to Production through a controlled promotion process",
          "Data drift occurs when the input distribution shifts from training data — detect with statistical tests (KS test, PSI) on feature distributions",
          "Concept drift occurs when the relationship between features and target changes — requires regular retraining even if data distribution looks stable",
          "CI/CD for ML (MLOps pipelines) automate retraining, evaluation, and conditional deployment when new data arrives or metrics degrade"
        ],
        "codeExample": "import mlflow, mlflow.sklearn\nfrom sklearn.ensemble import RandomForestClassifier\nfrom sklearn.metrics import f1_score\n\nmlflow.set_experiment('crop-yield-classifier')\n\nwith mlflow.start_run():\n    # Log parameters\n    params = { 'n_estimators': 200, 'max_depth': 8, 'min_samples_leaf': 5 }\n    mlflow.log_params(params)\n\n    model = RandomForestClassifier(**params)\n    model.fit(X_train, y_train)\n\n    # Log metrics\n    f1 = f1_score(y_test, model.predict(X_test), average='weighted')\n    mlflow.log_metric('f1_weighted', f1)\n\n    # Log model artifact\n    mlflow.sklearn.log_model(model, 'random_forest')",
        "deepDive": "Model monitoring in production requires a baseline: the distribution of model inputs and outputs during the period when the model was validated. Compare incoming request distributions against this baseline using distance metrics (Wasserstein, KL divergence). Set alerting thresholds that page the ML team before accuracy degrades to an unacceptable level — not after.",
        "summary": "MLflow + automated monitoring closes the loop between experimentation and production, making ML systems as operationally mature as traditional software."
      },
      "exercise": {
        "title": "Quiz: MLOps & Experiment Tracking",
        "timeLimit": 15,
        "questions": [
          {
            "id": 1,
            "question": "What is the difference between data drift and concept drift?",
            "options": [
              "Data drift is intentional; concept drift is a bug",
              "Data drift: input distribution changes. Concept drift: the relationship between inputs and the target variable changes",
              "Data drift affects training; concept drift affects inference",
              "They are the same phenomenon with different names"
            ],
            "correct": 1,
            "explanation": "Data drift: users start submitting different types of inputs (e.g. more mobile traffic). Concept drift: the same inputs now predict different outcomes (e.g. economic changes make a credit model's training patterns obsolete). Concept drift requires retraining; data drift may only require monitoring."
          },
          {
            "id": 2,
            "question": "What does mlflow.log_model() store?",
            "options": [
              "The model's training data",
              "The serialised model artifact along with its input/output schema and dependencies, versioned in the MLflow tracking server",
              "The training logs and error messages",
              "The model's prediction on the test set"
            ],
            "correct": 1,
            "explanation": "log_model() saves the serialised model (pickle, SavedModel, ONNX depending on flavour), an MLmodel file defining the flavour and input schema, and a conda.yaml / requirements.txt for environment reproduction — everything needed to reload and serve the model later."
          },
          {
            "id": 3,
            "question": "Why is experiment tracking important for ML teams?",
            "options": [
              "It makes model training faster",
              "It records parameters, metrics, and artifacts for every run — enabling reproducibility, comparison, and auditability across team members",
              "It automatically selects the best hyperparameters",
              "It replaces the need for version control"
            ],
            "correct": 1,
            "explanation": "Without tracking, you cannot reproduce a model from 3 months ago, compare two experiments systematically, or audit what model was in production on a given date. MLflow provides a searchable history of every experiment with full reproducibility information."
          }
        ]
      }
    },
    {
      "title": "Capstone: End-to-End ML System on African Agriculture Data",
      "duration": "150 min", "videoUrl": "",
      "description": "Build, evaluate, deploy, and monitor a full ML pipeline on a real dataset.",
      "notes": {
        "overview": "This capstone synthesises the full course into one deployable system: EDA on a real African crop yield dataset, feature engineering pipeline, model training with cross-validation, SHAP explainability, FastAPI deployment, and MLflow tracking. The deliverable is a live API endpoint and a written technical report suitable for a data science portfolio.",
        "keyPoints": [
          "Define the business question first: 'predict yield in tonnes/ha ±15%' not just 'build a model'",
          "Version your data (DVC or S3 versioned bucket) alongside your code so experiments are fully reproducible",
          "Model card documentation: training data summary, evaluation metrics, known limitations, intended use case — required for responsible AI deployment",
          "Canary deployment: route 5% of traffic to the new model, compare metrics against the baseline, promote to 100% only if performance improves",
          "Rollback plan: always maintain the previous model version ready to restore within minutes if the new model degrades"
        ],
        "codeExample": "# End-to-end pipeline checklist\n# 1. EDA\n#    df.describe(), histograms, correlation matrix, missing value audit\n# 2. Feature pipeline (sklearn Pipeline)\n#    impute -> encode -> scale -> select\n# 3. Model selection (cross-validated)\n#    LogReg baseline -> RF -> XGBoost\n# 4. Hyperparameter tuning (Optuna)\n#    study = optuna.create_study(direction='maximize')\n# 5. SHAP explainability\n#    shap.summary_plot(shap_values, X_test)\n# 6. FastAPI service\n#    /predict endpoint with Pydantic validation\n# 7. MLflow logging\n#    log params, metrics, model artifact\n# 8. Docker + deploy to Render\n#    docker build -t crop-api . && render deploy",
        "deepDive": "The biggest mistake in capstone projects is treating model accuracy as the only success metric. Real ML projects succeed when they answer the business question, are trusted by stakeholders (explainability), are monitored in production (drift detection), and can be maintained over time (reproducibility, documentation). A 72% accurate, well-documented, monitored, interpretable model is more valuable than a 91% black-box model that no one understands or trusts.",
        "summary": "An ML project is complete when it is deployed, monitored, documented, and stakeholders can understand and trust its predictions — not when training accuracy stops improving."
      },
      "exercise": {
        "title": "Quiz: End-to-End ML Project Design",
        "timeLimit": 25,
        "questions": [
          {
            "id": 1,
            "question": "What is a model card?",
            "options": [
              "A GPU specification sheet for training hardware",
              "A standardised documentation artifact describing a model's intended use, training data, evaluation results, limitations, and ethical considerations",
              "A summary of the model's architecture layers",
              "A marketing one-pager for the model's capabilities"
            ],
            "correct": 1,
            "explanation": "Model cards (introduced by Google, now an industry standard) document what a model does, what data it was trained on, how it was evaluated, where it performs poorly, and what it should/should not be used for — enabling informed deployment decisions and responsible AI governance."
          },
          {
            "id": 2,
            "question": "What is a canary deployment in the context of ML models?",
            "options": [
              "Deploying a model only in a test environment",
              "Routing a small fraction of real traffic to the new model to validate performance in production before full rollout",
              "Monitoring model predictions for anomalies",
              "A/B testing the model's UI"
            ],
            "correct": 1,
            "explanation": "A canary deployment exposes the new model to e.g. 5% of production traffic while 95% continues using the current model. This detects real-world degradation (unexpected input types, distribution shift, edge cases) with minimal risk before committing to a full rollout."
          },
          {
            "id": 3,
            "question": "Why is data versioning (e.g. with DVC) as important as code versioning?",
            "options": [
              "Data versioning is not important — only code matters for reproducibility",
              "An ML model's behaviour is determined by both code AND training data — without data versioning, you cannot reproduce a past experiment or audit what data a deployed model was trained on",
              "Data versioning reduces storage costs",
              "Data versioning enables faster training"
            ],
            "correct": 1,
            "explanation": "If training data changes without version control, you cannot reproduce model results from 6 months ago, cannot audit compliance questions ('what data was the production model trained on?'), and cannot detect training data contamination. DVC tracks data files in Git-compatible format."
          }
        ]
      }
    }
  ]
  $ds_extra$::jsonb
  FROM courses WHERE title = 'Data Science & Machine Learning'
)
WHERE title = 'Data Science & Machine Learning';


-- ============================================================
--  3. SOFTWARE ARCHITECTURE & DESIGN PATTERNS  (all 13)
-- ============================================================
UPDATE courses SET lessons = $sa$
[
  {
    "title": "Why Architecture Matters: Technical Debt, Coupling & Cyclomatic Complexity",
    "duration": "60 min", "videoUrl": "",
    "description": "Quantify code quality before and after refactoring.",
    "notes": {
      "overview": "Software architecture defines the high-level structure of a system — how components are organised, how they communicate, and what principles govern their evolution. Poor architecture accumulates technical debt: the compounding cost of shortcuts that slow future development. Measuring debt with tools (SonarQube, CodeClimate) makes it visible and manageable.",
      "keyPoints": [
        "Coupling measures how much a module depends on others — high coupling means a change in one module breaks many others",
        "Cohesion measures how focused a module is on one responsibility — high cohesion makes modules easier to understand, test, and reuse",
        "Cyclomatic complexity counts the number of independent paths through code — values above 10 predict high defect rates and test cost",
        "Technical debt accrues interest: a shortcut taken today slows every future feature that touches the same code",
        "The 'Boy Scout Rule': leave the codebase cleaner than you found it — incremental refactoring prevents debt from becoming unmanageable"
      ],
      "codeExample": "// High coupling — UserService knows about every other service\nclass UserService {\n  sendWelcomeEmail(user) { new EmailService().send(user.email, '...'); }\n  chargeSubscription(user) { new PaymentService().charge(user.card); }\n  logActivity(user) { new AnalyticsService().track(user.id); }\n}\n\n// Low coupling — UserService depends on an abstraction\nclass UserService {\n  constructor(private readonly events: EventBus) {}\n  register(user) { this.events.publish('user.registered', user); }\n}",
      "deepDive": "The biggest architectural mistake is premature optimisation of structure — over-engineering for hypothetical future requirements that never materialise. Follow YAGNI (You Aren't Gonna Need It): add complexity only when the actual need appears. The second biggest mistake is under-engineering: not addressing coupling and cohesion until the codebase becomes unmaintainable. Balance is achieved by following established principles without gold-plating.",
      "summary": "Good architecture reduces the cost of change — measure it, track it as a team metric, and pay down debt incrementally with every sprint."
    },
    "exercise": {
      "title": "Quiz: Architecture Quality Metrics",
      "timeLimit": 12,
      "questions": [
        {
          "id": 1,
          "question": "What is the difference between coupling and cohesion?",
          "options": [
            "Coupling is a property of functions; cohesion is a property of classes",
            "Coupling measures inter-module dependencies (lower is better); cohesion measures intra-module focus (higher is better)",
            "They are opposite names for the same metric",
            "Coupling applies to databases; cohesion applies to APIs"
          ],
          "correct": 1,
          "explanation": "Coupling: how much module A depends on module B. Low coupling means changes to B don't break A. Cohesion: how well a module's internals belong together. High cohesion means the module does one thing well. The goal is low coupling, high cohesion."
        },
        {
          "id": 2,
          "question": "What does cyclomatic complexity measure?",
          "options": [
            "The number of classes in a codebase",
            "The number of independent execution paths through a function — a proxy for testability and defect probability",
            "The depth of class inheritance hierarchies",
            "The number of external dependencies a module has"
          ],
          "correct": 1,
          "explanation": "Cyclomatic complexity = edges - nodes + 2 in the control flow graph, which equals the number of linearly independent paths. A function with CC = 15 requires 15 test cases to cover all paths and is statistically more likely to contain defects."
        },
        {
          "id": 3,
          "question": "What does technical debt 'interest' mean in software?",
          "options": [
            "The financial cost of software licenses",
            "The extra effort required to work around or fix shortcuts in future — shortcuts compound, slowing all future development that touches the affected code",
            "The time cost of code reviews",
            "The overhead of managing external dependencies"
          ],
          "correct": 1,
          "explanation": "Like financial debt, technical debt accrues interest. A shortcut today adds friction to every future change in that area. A workaround in a core module can slow team velocity by 20–50% over time as more and more features require navigating that complexity."
        }
      ]
    }
  },
  {
    "title": "SOLID Principles: Theory, Anti-Patterns & Refactoring Exercises",
    "duration": "85 min", "videoUrl": "",
    "description": "Work through 5 real codebases that violate each SOLID principle.",
    "notes": {
      "overview": "SOLID is an acronym for five object-oriented design principles introduced by Robert C. Martin. They guide how to structure classes and modules to be flexible, maintainable, and testable. Each principle addresses a specific failure mode in software design.",
      "keyPoints": [
        "S — Single Responsibility: a class should have only one reason to change (one actor who can demand a change)",
        "O — Open/Closed: classes should be open for extension but closed for modification — add behaviour via new code, not by editing existing code",
        "L — Liskov Substitution: a subclass must be usable wherever its base class is used without altering correctness",
        "I — Interface Segregation: prefer many small, focused interfaces over one large fat interface — clients should not implement methods they don't use",
        "D — Dependency Inversion: high-level modules should not depend on low-level modules — both should depend on abstractions"
      ],
      "codeExample": "// Violates DIP — OrderService depends directly on MySQLDatabase\nclass OrderService {\n  saveOrder(order) { new MySQLDatabase().save(order); }\n}\n\n// Follows DIP — depends on abstraction\ninterface OrderRepository { save(order: Order): Promise<void>; }\n\nclass OrderService {\n  constructor(private repo: OrderRepository) {}\n  async placeOrder(order: Order) { await this.repo.save(order); }\n}\n// Inject MySQLOrderRepository in production, InMemoryOrderRepository in tests",
      "deepDive": "The Dependency Inversion Principle is the foundation of testability. When high-level business logic depends directly on infrastructure (databases, HTTP clients, file systems), unit tests require running those systems. Injecting abstractions (interfaces) allows replacing real dependencies with fast, controllable fakes in tests — this is why DI containers are central to enterprise architectures.",
      "summary": "SOLID principles are not rules to follow blindly — they are diagnostic lenses: when code is hard to change, test, or extend, ask which principle it violates and refactor accordingly."
    },
    "exercise": {
      "title": "Quiz: SOLID Principles",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "A class EmailSender has methods sendWelcome(), sendInvoice(), sendPasswordReset(), formatHtml(), and connectToSmtp(). Which principle does this violate most?",
          "options": [
            "Open/Closed Principle",
            "Single Responsibility Principle — it handles formatting, connection management, and multiple email types",
            "Liskov Substitution Principle",
            "Dependency Inversion Principle"
          ],
          "correct": 1,
          "explanation": "SRP: a class should have one reason to change. This class has multiple: email content changes require modifying it, SMTP configuration changes require modifying it, HTML template changes require modifying it. Split into EmailTemplates, SmtpConnector, and EmailSender."
        },
        {
          "id": 2,
          "question": "What is the key test for Liskov Substitution Principle compliance?",
          "options": [
            "The subclass compiles without errors",
            "Code that works correctly with the base class continues to work correctly when a subclass instance is substituted",
            "The subclass does not override any methods",
            "The subclass implements all interface methods"
          ],
          "correct": 1,
          "explanation": "LSP is violated when substituting a subclass breaks caller expectations. Classic violation: Square extends Rectangle and overrides setWidth() to also set height. Code that sets width and height independently now produces unexpected results with a Square — a Square is NOT a Rectangle for the purposes of this code."
        },
        {
          "id": 3,
          "question": "What does the Dependency Inversion Principle enable in testing?",
          "options": [
            "Tests run faster with DIP",
            "Injecting test doubles (mocks, stubs, fakes) instead of real dependencies like databases and HTTP clients — enabling fast, isolated unit tests",
            "DIP generates test cases automatically",
            "DIP allows tests to run in parallel"
          ],
          "correct": 1,
          "explanation": "When a class depends on an interface (abstraction) rather than a concrete class, you can inject a fast in-memory fake in tests. Without DIP, testing a service that directly instantiates a database connection requires running a real database in every test."
        }
      ]
    }
  },
  {
    "title": "Creational Patterns: Singleton, Factory Method, Abstract Factory, Builder & Prototype",
    "duration": "75 min", "videoUrl": "",
    "description": "When to use each pattern and TypeScript implementations.",
    "notes": {
      "overview": "Creational patterns abstract the instantiation process — they let a system be independent of how its objects are created, composed, and represented. Each pattern solves a specific instantiation problem: controlling instances (Singleton), delegating creation (Factory), swapping families (Abstract Factory), constructing complex objects step-by-step (Builder), or cloning (Prototype).",
      "keyPoints": [
        "Singleton ensures one instance per process — use carefully; global singletons are hidden dependencies that make testing difficult",
        "Factory Method lets subclasses decide which class to instantiate — the base class defines the interface, concrete factories provide implementations",
        "Abstract Factory creates families of related objects without specifying concrete classes — useful for multi-platform UI components",
        "Builder constructs complex objects step-by-step; the same construction process can create different representations",
        "Prototype clones existing objects rather than constructing from scratch — used when construction is expensive or complex"
      ],
      "codeExample": "// Builder pattern — constructing complex query objects\nclass QueryBuilder {\n  private conditions: string[] = [];\n  private limitVal = 100;\n\n  where(condition: string) { this.conditions.push(condition); return this; }\n  limit(n: number) { this.limitVal = n; return this; }\n  build(): string {\n    const where = this.conditions.length ? `WHERE ${this.conditions.join(' AND ')}` : '';\n    return `SELECT * FROM courses ${where} LIMIT ${this.limitVal}`;\n  }\n}\n\nconst query = new QueryBuilder()\n  .where('rating > 4.5')\n  .where('is_free = true')\n  .limit(10)\n  .build();",
      "deepDive": "The Singleton pattern is the most misused design pattern. Its legitimate use cases are narrow: configuration singletons, connection pools, and registry patterns. In most other cases, a singleton is just global mutable state with extra steps — it creates hidden coupling between classes that 'just grab' the singleton, making the dependency invisible and tests impossible without resetting global state.",
      "summary": "Creational patterns shift object creation from scattered new() calls into well-defined locations — making it easy to swap implementations, test with fakes, and manage complex object lifecycles."
    },
    "exercise": {
      "title": "Quiz: Creational Design Patterns",
      "timeLimit": 15,
      "questions": [
        {
          "id": 1,
          "question": "What problem does the Builder pattern solve?",
          "options": [
            "Ensuring only one instance of a class exists",
            "Constructing complex objects step-by-step when the constructor would require many optional parameters",
            "Creating families of related objects",
            "Cloning existing objects without specifying their concrete class"
          ],
          "correct": 1,
          "explanation": "Builder is the antidote to 'telescoping constructors' — a class with so many optional parameters that calling new() requires passing many nulls. Builder chains method calls, only setting what's needed, and returns the object from build()."
        },
        {
          "id": 2,
          "question": "Why is Singleton considered problematic for testability?",
          "options": [
            "Singletons are slow to instantiate",
            "Singletons introduce hidden global state — classes that access them are secretly dependent on global state, making tests order-dependent and hard to isolate",
            "Singletons cannot be subclassed",
            "Singletons increase memory usage"
          ],
          "correct": 1,
          "explanation": "When test A modifies the Singleton's state, test B (which also uses the Singleton) sees contaminated state. Tests become order-dependent. You cannot create an independent, isolated test environment because the Singleton persists between tests."
        },
        {
          "id": 3,
          "question": "What distinguishes Factory Method from Abstract Factory?",
          "options": [
            "Factory Method creates objects; Abstract Factory only defines interfaces",
            "Factory Method creates one product type via a single method; Abstract Factory creates families of related products via multiple factory methods",
            "Abstract Factory is more performant than Factory Method",
            "They are the same pattern with different names"
          ],
          "correct": 1,
          "explanation": "Factory Method has one creation method that subclasses override to create one product type. Abstract Factory groups multiple factory methods together to create families of related products — e.g. a WindowsUIFactory creates WindowsButton + WindowsDialog; a MacUIFactory creates MacButton + MacDialog."
        }
      ]
    }
  },
  {
    "title": "Structural Patterns: Adapter, Bridge, Composite, Decorator, Facade, Flyweight & Proxy",
    "duration": "80 min", "videoUrl": "",
    "description": "Compose objects flexibly and build a plugin system.",
    "notes": {
      "overview": "Structural patterns describe how to compose objects and classes into larger structures while keeping those structures flexible and efficient. They solve problems of incompatible interfaces (Adapter), separating abstraction from implementation (Bridge), tree structures (Composite), adding behaviour without subclassing (Decorator), simplifying complex subsystems (Facade), sharing state (Flyweight), and controlled access (Proxy).",
      "keyPoints": [
        "Adapter converts one interface to another — useful when integrating third-party libraries without modifying their code",
        "Decorator wraps an object to add behaviour before/after delegation — the foundation of middleware pipelines and plugin systems",
        "Facade provides a simple, unified interface to a complex subsystem — clients interact with the facade instead of many internal classes",
        "Proxy controls access to an object — uses: lazy initialisation, logging, caching, access control, remote proxies",
        "Composite lets clients treat individual objects and groups (trees) uniformly — used in file systems, UI component trees, and menus"
      ],
      "codeExample": "// Decorator pattern — middleware chain\ninterface Handler { handle(req: Request): Response; }\n\nclass LoggingDecorator implements Handler {\n  constructor(private next: Handler) {}\n  handle(req: Request): Response {\n    console.log(`[${Date.now()}] ${req.method} ${req.path}`);\n    const res = this.next.handle(req);\n    console.log(`→ ${res.status}`);\n    return res;\n  }\n}\n\nconst handler = new LoggingDecorator(\n  new AuthDecorator(\n    new RateLimitDecorator(\n      new CoreHandler()\n    )\n  )\n);",
      "deepDive": "Express.js middleware IS the Decorator pattern applied to request handling. Each middleware wraps the next with next() replacing delegation. Understanding this equivalence is why the pattern feels immediately familiar to Node.js developers — they have been using structural patterns without naming them.",
      "summary": "Structural patterns let you add behaviour, simplify interfaces, and control access through composition rather than inheritance — keeping systems flexible and open for extension."
    },
    "exercise": {
      "title": "Quiz: Structural Design Patterns",
      "timeLimit": 16,
      "questions": [
        {
          "id": 1,
          "question": "Which pattern does Express.js middleware implement?",
          "options": ["Facade", "Proxy", "Decorator", "Adapter"],
          "correct": 2,
          "explanation": "Express middleware wraps a request handler: each middleware calls next() to delegate to the next handler, optionally adding behaviour before/after. This is exactly the Decorator pattern — a chain of wrappers each adding a cross-cutting concern (logging, auth, rate-limiting)."
        },
        {
          "id": 2,
          "question": "When would you use the Adapter pattern?",
          "options": [
            "To add logging to existing methods",
            "To make an incompatible third-party interface work with your existing code without modifying the third-party library",
            "To provide a simple interface to a complex subsystem",
            "To create a tree structure of objects"
          ],
          "correct": 1,
          "explanation": "Adapter is a compatibility layer. When integrating a payment gateway with a different method signature than your PaymentProcessor interface, an Adapter implements your interface and translates calls to the third-party API — no changes to your codebase or the external library."
        },
        {
          "id": 3,
          "question": "How does a Proxy differ from a Decorator?",
          "options": [
            "A Proxy adds new behaviour; a Decorator controls access",
            "A Proxy controls or intercepts access to an object (lazy loading, caching, auth); a Decorator adds behaviour transparently without changing the interface's purpose",
            "A Proxy wraps multiple objects; a Decorator wraps one",
            "They are identical patterns"
          ],
          "correct": 1,
          "explanation": "Intent distinguishes them: Decorator enriches an object's behaviour (add logging, validation). Proxy controls access (lazy load an expensive object only when first used, check permissions before delegating, cache remote call results). Both implement the same interface as the wrapped object."
        }
      ]
    }
  },
  {
    "title": "Behavioural Patterns: Chain of Responsibility, Command, Observer, Strategy & Template Method",
    "duration": "90 min", "videoUrl": "",
    "description": "Implement an event bus, undo/redo system, and a rule engine.",
    "notes": {
      "overview": "Behavioural patterns focus on algorithms and the assignment of responsibilities between objects. They describe not just patterns of objects and classes but also the patterns of communication between them. The most commonly encountered in modern software: Observer (event systems), Strategy (algorithm selection), Command (undo/redo), Chain of Responsibility (middleware pipelines), and Template Method (framework hooks).",
      "keyPoints": [
        "Observer defines a one-to-many dependency — when one object changes state, all dependents are notified automatically (DOM events, RxJS, EventEmitter)",
        "Strategy encapsulates a family of algorithms, making them interchangeable — select the algorithm at runtime without changing the client",
        "Command encapsulates a request as an object — enables undo/redo, queuing, logging, and macro recording",
        "Chain of Responsibility passes a request along a chain of handlers — each handler decides to process or pass it on (Express middleware, validation pipelines)",
        "Template Method defines the skeleton of an algorithm in a base class, deferring specific steps to subclasses — used in frameworks that call your hooks"
      ],
      "codeExample": "// Observer pattern — type-safe event bus\ntype Events = { 'user.enrolled': { userId: string; courseId: string }; };\n\nclass EventBus {\n  private listeners = new Map<string, Function[]>();\n  on<K extends keyof Events>(event: K, fn: (data: Events[K]) => void) {\n    const fns = this.listeners.get(event) ?? [];\n    this.listeners.set(event, [...fns, fn]);\n  }\n  emit<K extends keyof Events>(event: K, data: Events[K]) {\n    this.listeners.get(event)?.forEach(fn => fn(data));\n  }\n}\n\nbus.on('user.enrolled', ({ userId, courseId }) => sendEnrollmentEmail(userId, courseId));\nbus.on('user.enrolled', ({ courseId }) => updateCourseStudentCount(courseId));",
      "deepDive": "The Strategy pattern is the object-oriented alternative to long if/else chains that select different algorithms. Rather than if (type === 'credit') { ... } else if (type === 'crypto') { ... }, inject a PaymentStrategy and call strategy.process(). Adding a new payment type means creating a new Strategy class — the caller's code never changes. This is the Open/Closed Principle in action.",
      "summary": "Behavioural patterns replace conditional logic and tight coupling between algorithms and callers with composable, extensible object collaborations."
    },
    "exercise": {
      "title": "Quiz: Behavioural Design Patterns",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "Which pattern does Node.js EventEmitter implement?",
          "options": ["Command", "Observer", "Strategy", "Chain of Responsibility"],
          "correct": 1,
          "explanation": "EventEmitter is the Observer (Pub/Sub) pattern. Listeners register with emitter.on(event, handler), and emitter.emit(event, data) notifies all registered handlers — classic one-to-many dependency notification."
        },
        {
          "id": 2,
          "question": "What capability does the Command pattern uniquely enable?",
          "options": [
            "Routing requests to different handlers",
            "Undo/redo by storing executed commands as objects and calling their inverse operation",
            "Dynamically swapping algorithms at runtime",
            "Notifying multiple subscribers of state changes"
          ],
          "correct": 1,
          "explanation": "Command encapsulates a request as an object with execute() and undo() methods. Storing executed commands on a stack enables time-travel: call undo() to reverse the last command, push to redo stack for redo functionality."
        },
        {
          "id": 3,
          "question": "How does Strategy differ from Template Method?",
          "options": [
            "Strategy uses inheritance; Template Method uses composition",
            "Strategy selects an algorithm object at runtime via composition; Template Method defines an algorithm skeleton in a base class and defers steps to subclasses via inheritance",
            "They solve identical problems",
            "Template Method is newer and replaces Strategy"
          ],
          "correct": 1,
          "explanation": "Strategy: inject the varying algorithm as a collaborating object (composition). Template Method: inherit from a base class that defines the algorithm skeleton with abstract hook methods you override. Prefer Strategy (composition over inheritance) unless framework integration requires inheritance."
        }
      ]
    }
  },
  {
    "title": "Clean Architecture & Hexagonal Architecture",
    "duration": "90 min", "videoUrl": "",
    "description": "Build business rules with zero dependencies on frameworks or databases.",
    "notes": {
      "overview": "Clean Architecture (Robert C. Martin) organises code in concentric rings: Entities (core business rules) at the centre, Use Cases (application business rules) around them, then Interface Adapters, then Frameworks & Drivers at the outermost ring. The Dependency Rule states that source code dependencies can only point inward — inner rings know nothing about outer rings.",
      "keyPoints": [
        "Entities contain enterprise-wide business rules — they are the most stable, valuable code and have no dependencies on any framework or database",
        "Use Cases (Interactors) orchestrate entities to fulfil application-specific goals — they depend on entity interfaces, not implementations",
        "Interface Adapters (Controllers, Presenters, Gateways) convert data between use-case format and external agent format",
        "The Dependency Rule enforced: use cases call repository interfaces defined in the domain layer; SQL implementations live in the outer adapter layer",
        "Hexagonal Architecture (Ports & Adapters) is a related pattern — Ports are interfaces; Adapters are implementations of those interfaces for specific technologies"
      ],
      "codeExample": "// Domain layer — no imports from Express, Postgres, or any framework\nexport class Course {\n  constructor(readonly id: string, readonly title: string, readonly rating: number) {}\n  isHighlyRated() { return this.rating >= 4.5; }\n}\n\nexport interface CourseRepository {  // Port\n  findById(id: string): Promise<Course | null>;\n  save(course: Course): Promise<void>;\n}\n\nexport class EnrollUseCase {\n  constructor(private courses: CourseRepository) {}\n  async execute(courseId: string, userId: string) {\n    const course = await this.courses.findById(courseId);\n    if (!course) throw new Error('Course not found');\n    // pure business logic — no SQL, no HTTP\n  }\n}",
      "deepDive": "The key test of Clean Architecture compliance: can you run your entire use case test suite without starting a database, web server, or any external service? If yes, your business logic is truly decoupled. If unit testing a use case requires a running Postgres instance, your dependency rule is violated somewhere — probably a use case that imports directly from a concrete repository class.",
      "summary": "Clean Architecture makes the business logic the most important, stable, and independently testable part of the system — everything else is a replaceable detail."
    },
    "exercise": {
      "title": "Quiz: Clean & Hexagonal Architecture",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "What is the Dependency Rule in Clean Architecture?",
          "options": [
            "Dependencies should point outward from the core to the infrastructure layer",
            "Source code dependencies can only point inward — inner rings (business rules) must not import from outer rings (frameworks, databases)",
            "All dependencies should be injected via a DI container",
            "Each layer can only import from adjacent layers"
          ],
          "correct": 1,
          "explanation": "The Dependency Rule is the central constraint: Entities cannot import from Use Cases; Use Cases cannot import from Controllers or Databases. Outer rings depend on inner rings via interfaces. This makes the inner rings stable and independently deployable."
        },
        {
          "id": 2,
          "question": "In Hexagonal Architecture, what is a 'Port'?",
          "options": [
            "A TCP port number for the application's HTTP server",
            "An interface defined in the domain layer that describes what an outer system must provide — a contract without implementation details",
            "A module entry point in the package structure",
            "A messaging queue connection"
          ],
          "correct": 1,
          "explanation": "A Port is an interface (abstraction) in the domain: CourseRepository, EmailSender, PaymentGateway. An Adapter is a concrete implementation of that interface for a specific technology: PostgresCourseRepository, SendgridEmailSender. The domain depends on Ports; Adapters implement Ports."
        },
        {
          "id": 3,
          "question": "What is the practical test to verify your architecture follows the Dependency Rule?",
          "options": [
            "Run the application without any configuration",
            "Run all use case unit tests without starting a database, web server, or any external service",
            "Delete all framework code and see if the application still compiles",
            "Measure cyclomatic complexity of the domain layer"
          ],
          "correct": 1,
          "explanation": "If use case tests require a running database or web server, business logic has a concrete dependency on infrastructure. Clean Architecture unit tests should run in milliseconds using in-memory fakes for all external dependencies."
        }
      ]
    }
  },
  {
    "title": "Domain-Driven Design: Entities, Value Objects, Aggregates & Bounded Contexts",
    "duration": "95 min", "videoUrl": "",
    "description": "Model a real e-learning domain with DDD building blocks.",
    "notes": {
      "overview": "Domain-Driven Design (DDD) aligns software models with business domain concepts. The Ubiquitous Language — a shared vocabulary between developers and domain experts — ensures the code reflects real business rules. DDD building blocks (Entities, Value Objects, Aggregates, Domain Events, Repositories) provide a consistent vocabulary for modelling complex domains.",
      "keyPoints": [
        "Entity: has identity (id) that persists across state changes — two entities with the same id are the same thing, regardless of field values",
        "Value Object: defined entirely by its attributes, has no identity — two Value Objects with the same values are interchangeable (Money(100, 'USD'))",
        "Aggregate: a cluster of entities and value objects with a single root (Aggregate Root) — all external access goes through the root, which maintains invariants",
        "Bounded Context: an explicit boundary within which a model applies — 'Course' means different things in the Catalogue context vs the Billing context",
        "Domain Events communicate what happened ('CoursePublished', 'StudentEnrolled') — they decouple bounded contexts and drive eventual consistency"
      ],
      "codeExample": "// Value Object — immutable, equality by value\nclass Money {\n  constructor(readonly amount: number, readonly currency: string) {\n    if (amount < 0) throw new Error('Amount cannot be negative');\n  }\n  add(other: Money): Money {\n    if (this.currency !== other.currency) throw new Error('Currency mismatch');\n    return new Money(this.amount + other.amount, this.currency);\n  }\n  equals(other: Money) { return this.amount === other.amount && this.currency === other.currency; }\n}\n\n// Aggregate Root protecting invariants\nclass CourseEnrollment {\n  private _completedLessons: number[] = [];\n  get progress() { return Math.round(this._completedLessons.length / this.totalLessons * 100); }\n  completeLesson(index: number) {\n    if (index >= this.totalLessons) throw new Error('Invalid lesson');\n    if (!this._completedLessons.includes(index)) this._completedLessons.push(index);\n    if (this.progress === 100) this.addEvent(new CourseCompleted(this.id));\n  }\n}",
      "deepDive": "Bounded Contexts are perhaps the most valuable DDD concept for large teams. Without explicit boundaries, a single 'User' object grows to serve every context: authentication, billing, communication, analytics — becoming an unmaintainable God Object. Separate contexts have separate models. A User in AuthContext has {id, email, passwordHash}; in BillingContext {id, plan, paymentMethod}. They communicate via domain events, not shared database tables.",
      "summary": "DDD's language-first approach ensures the code expresses real business rules rather than database schemas — making the domain model the single source of truth for business logic."
    },
    "exercise": {
      "title": "Quiz: Domain-Driven Design",
      "timeLimit": 19,
      "questions": [
        {
          "id": 1,
          "question": "What is the key difference between an Entity and a Value Object?",
          "options": [
            "Entities have methods; Value Objects have only properties",
            "Entities have unique identity (id) and are tracked through state changes; Value Objects are defined entirely by their attribute values and have no separate identity",
            "Entities are stored in databases; Value Objects are only in memory",
            "Entities are mutable; Value Objects are immutable"
          ],
          "correct": 1,
          "explanation": "Identity is the distinction. Two Student entities with id='123' are the same student even if their name or email changed. Two Money(50, 'USD') value objects are interchangeable — there is no 'which $50' question. Value Objects should also be immutable; mutation creates a new instance."
        },
        {
          "id": 2,
          "question": "What is an Aggregate Root's responsibility?",
          "options": [
            "To serve as the database primary key for the aggregate's entities",
            "To enforce all invariants for the aggregate — external code can only modify the aggregate through the root, which ensures business rules are never violated",
            "To generate domain events for all entities in the aggregate",
            "To provide a facade interface to the bounded context"
          ],
          "correct": 1,
          "explanation": "The Aggregate Root is the guardian of consistency. All access to entities within the aggregate goes through the root, which validates business rules before applying changes. Direct access to child entities bypasses these rules — which is why Aggregate Roots should be the only objects loaded from repositories."
        },
        {
          "id": 3,
          "question": "What problem do Bounded Contexts solve?",
          "options": [
            "They improve database query performance",
            "They prevent 'God objects' — a single model trying to serve all contexts in a large domain ends up satisfying none of them well",
            "They define security boundaries in a multi-tenant system",
            "They organise microservices by deployment boundary"
          ],
          "correct": 1,
          "explanation": "Without Bounded Contexts, teams share one model (e.g. 'Product') that accumulates all meanings of that term across the organisation — shipping, pricing, inventory, analytics. Each context has a lean model tailored to its needs, communicating via well-defined contracts (domain events, APIs)."
        }
      ]
    }
  },
  {
    "title": "Microservices: Decomposition, Service Mesh & the Strangler Fig Pattern",
    "duration": "100 min", "videoUrl": "",
    "description": "Break a monolith incrementally and handle partial failure.",
    "notes": {
      "overview": "Microservices decompose a monolith into small, independently deployable services that communicate over a network. The key benefit is independent deployability: changing the Payments service does not require redeploying the Courses service. The key cost is distributed systems complexity: network latency, partial failure, eventual consistency, and distributed tracing.",
      "keyPoints": [
        "Decompose by business capability (Courses, Users, Billing, Notifications) not by technical layer (DB layer, API layer) — each service owns its full stack",
        "The Strangler Fig Pattern incrementally replaces monolith functionality: route a single capability to a new service, verify, repeat — no big-bang rewrite",
        "Service-to-service communication: synchronous (REST/gRPC for queries), asynchronous (Kafka/RabbitMQ for events that decouple services)",
        "The Circuit Breaker pattern prevents cascade failures: after N consecutive failures, trips open and returns fast fallback responses without calling the downstream service",
        "Distributed tracing (OpenTelemetry + Jaeger) propagates a trace ID across service boundaries, making it possible to reconstruct the full request journey"
      ],
      "codeExample": "// Circuit Breaker with opossum\nimport CircuitBreaker from 'opossum';\n\nconst options = {\n  timeout: 3000,          // fail if no response in 3s\n  errorThresholdPercentage: 50,  // trip after 50% errors\n  resetTimeout: 30000     // retry after 30s\n};\n\nconst breaker = new CircuitBreaker(callEnrollmentService, options);\nbreaker.fallback(() => ({ enrolled: false, reason: 'service unavailable' }));\nbreaker.on('open', () => logger.warn('Enrollment service circuit breaker opened'));\n\n// Usage\nconst result = await breaker.fire(userId, courseId);",
      "deepDive": "The most common microservices mistake is premature decomposition. A team of 5 engineers extracting 30 microservices creates enormous operational overhead: 30 deployment pipelines, 30 monitoring dashboards, distributed tracing for every request, and complex saga patterns for every transaction. Start with a monolith (or 3–5 large services) and extract only when a specific service has independent scaling requirements or is causing deployment bottlenecks.",
      "summary": "Microservices are a scaling mechanism for teams and deployments — choose them when the organisational pain of coupling outweighs the operational complexity of distributed systems."
    },
    "exercise": {
      "title": "Quiz: Microservices Architecture",
      "timeLimit": 20,
      "questions": [
        {
          "id": 1,
          "question": "What is the Strangler Fig Pattern?",
          "options": [
            "A pattern for killing legacy code immediately",
            "An incremental migration strategy: route specific capabilities to new services one at a time, letting the new system grow around and eventually replace the monolith",
            "A pattern for strangling memory leaks in microservices",
            "A deployment pattern that runs old and new services in parallel permanently"
          ],
          "correct": 1,
          "explanation": "The Strangler Fig (named after the strangler fig tree that grows around an existing tree) migrates a monolith incrementally. You add a routing layer, route one capability to a new service, verify it works, then route the next. The monolith shrinks until nothing is left — without a risky big-bang rewrite."
        },
        {
          "id": 2,
          "question": "What does a Circuit Breaker do when it 'trips open'?",
          "options": [
            "It restarts the failed downstream service",
            "It stops sending requests to the failing service and immediately returns a fallback response, preventing cascade failures",
            "It logs the error and retries indefinitely",
            "It routes requests to a backup instance of the failing service"
          ],
          "correct": 1,
          "explanation": "An open circuit breaker short-circuits: instead of waiting for a timed-out request to a broken downstream service, it immediately returns a cached or error fallback response. This prevents one slow service from causing threads/connections to pile up and cascade-failing the entire system."
        },
        {
          "id": 3,
          "question": "Why should microservices communicate asynchronously (via events) rather than synchronously where possible?",
          "options": [
            "Asynchronous communication is always faster",
            "Synchronous calls create temporal coupling — Service A cannot process a request if Service B is down; events decouple services so each processes independently",
            "Event systems are easier to implement than REST APIs",
            "Synchronous calls cannot handle high throughput"
          ],
          "correct": 1,
          "explanation": "Synchronous REST chains services: if the Notifications service is down, the Enrollment service call fails even though enrolling a student has nothing to do with notifications. Publishing a 'user.enrolled' event lets Notifications consume it when it recovers — temporal decoupling."
        }
      ]
    }
  },
  {
    "title": "Event-Driven Architecture: Kafka, Event Sourcing & the Outbox Pattern",
    "duration": "90 min", "videoUrl": "",
    "description": "Build a reliable event pipeline and avoid dual-write inconsistencies.",
    "notes": {
      "overview": "Event-Driven Architecture (EDA) uses events — records of things that happened — as the primary communication mechanism between services. Apache Kafka is the dominant event streaming platform: messages are persisted to partitioned, replicated logs and consumers can replay from any offset. Event Sourcing stores the sequence of domain events as the source of truth, deriving current state by replaying them.",
      "keyPoints": [
        "Kafka topics are partitioned logs — producers append events; consumers maintain their own offset, enabling independent replay and reprocessing",
        "Consumer groups allow multiple service instances to share load: each partition is consumed by exactly one instance in a group",
        "Event Sourcing: instead of storing current state (UPDATE SET progress=75), store events (LessonCompleted, ProgressUpdated) and derive state by replaying",
        "The Outbox Pattern solves the dual-write problem: write the event to an outbox table in the same database transaction as the business data, then a relay process publishes it to Kafka — guaranteeing exactly-once delivery",
        "Exactly-once semantics require idempotent consumers: processing the same event twice must produce the same result as processing it once"
      ],
      "codeExample": "// Outbox Pattern — atomic write to DB + outbox\nasync function enrollStudent(userId, courseId, db) {\n  await db.transaction(async (trx) => {\n    // Business operation\n    await trx('enrollments').insert({ user_id: userId, course_id: courseId });\n\n    // Write to outbox in same transaction — never lost\n    await trx('outbox_events').insert({\n      aggregate_type: 'Enrollment',\n      event_type: 'student.enrolled',\n      payload: JSON.stringify({ userId, courseId }),\n      created_at: new Date()\n    });\n  });\n  // Relay worker polls outbox and publishes to Kafka\n}",
      "deepDive": "The dual-write problem: if you write to the database and then publish to Kafka in two separate operations, a crash between them leaves the systems inconsistent — either the DB was updated without the event being published, or the event was published without the DB being updated. The Outbox Pattern makes both operations atomic within a single database transaction, then the relay publishes at-least-once from the outbox.",
      "summary": "Event-driven systems achieve temporal decoupling and resilience at the cost of eventual consistency — the Outbox Pattern ensures events are reliably published even under failures."
    },
    "exercise": {
      "title": "Quiz: Event-Driven Architecture & Kafka",
      "timeLimit": 18,
      "questions": [
        {
          "id": 1,
          "question": "What is the dual-write problem in event-driven systems?",
          "options": [
            "Writing the same event to two different Kafka topics",
            "A crash between writing to the database and publishing to the message broker leaves both systems in an inconsistent state",
            "Two consumers processing the same event simultaneously",
            "A producer writing to a partition that has failed"
          ],
          "correct": 1,
          "explanation": "Without atomicity, a failure between DB write and Kafka publish causes inconsistency: the DB says the enrollment happened but no event was published (email not sent, analytics not updated). The Outbox Pattern solves this by writing both in one atomic transaction."
        },
        {
          "id": 2,
          "question": "In Event Sourcing, what is the 'source of truth'?",
          "options": [
            "The current state stored in the main database table",
            "The append-only sequence of domain events — current state is derived by replaying events from the beginning (or from a snapshot)",
            "The Kafka topic containing the events",
            "The most recent snapshot of the aggregate"
          ],
          "correct": 1,
          "explanation": "Event Sourcing never overwrites data. The events are immutable facts ('LessonCompleted at 14:32'). Current state (progress = 75%) is computed by replaying all events for an aggregate. This enables complete audit history, time-travel debugging, and projecting historical state at any point in time."
        },
        {
          "id": 3,
          "question": "What does Kafka's consumer group mechanism provide?",
          "options": [
            "Message ordering across all topics",
            "Load balancing: partitions are distributed across group members so the service scales horizontally — adding instances increases throughput proportionally",
            "Message deduplication across consumers",
            "Automatic schema evolution for messages"
          ],
          "correct": 1,
          "explanation": "In a consumer group, each Kafka partition is consumed by exactly one member. With 10 partitions and 5 consumer instances, each instance handles 2 partitions. Adding a 10th instance gives each instance one partition — linear horizontal scaling."
        }
      ]
    }
  },
  {
    "title": "CQRS: Separating Command and Query Models",
    "duration": "75 min", "videoUrl": "",
    "description": "Build separate write and read models optimised for each access pattern.",
    "notes": {
      "overview": "CQRS (Command Query Responsibility Segregation) separates operations that change state (Commands) from operations that read state (Queries). This allows the write model to be optimised for consistency and invariant enforcement while the read model is optimised for query performance — often a completely different data structure (denormalised view, search index, cache).",
      "keyPoints": [
        "Commands (CreateCourse, EnrollStudent) change state and return void or a success/failure indicator — never return data",
        "Queries (GetCourseDetails, GetStudentProgress) return data and must not change state — they are safe to cache and replay",
        "The write side uses a normalised, consistency-optimised schema; the read side uses denormalised projections optimised for specific query patterns",
        "Event sourcing pairs naturally with CQRS: commands produce events; event handlers update the read models (projections)",
        "Read model projections can be rebuilt from scratch by replaying the event log — making them disposable and schema-evolution friendly"
      ],
      "codeExample": "// Command handler — validates and applies\nasync function handleEnrollCommand(cmd: EnrollStudentCommand) {\n  const course = await courseRepo.findById(cmd.courseId);\n  if (!course.hasCapacity()) throw new Error('Course is full');\n  course.enroll(cmd.studentId);  // emits StudentEnrolled event\n  await courseRepo.save(course);\n}\n\n// Read model projection — updated by event handler\nasync function onStudentEnrolled(event: StudentEnrolledEvent) {\n  await db('course_enrollment_view').insert({\n    course_id: event.courseId,\n    student_id: event.studentId,\n    enrolled_at: event.occurredAt,\n    course_title: event.courseTitle   // denormalised for query efficiency\n  });\n}",
      "deepDive": "CQRS introduces eventual consistency: after a command is processed, the read model update happens asynchronously (milliseconds to seconds delay). The UI must handle this — show optimistic updates after a command, and refresh from the read model after a short delay. This tradeoff is acceptable for most cases but not for financial transactions where strong consistency is required.",
      "summary": "CQRS separates concerns at the model level — write models enforce business rules, read models serve queries at any scale without impacting write performance."
    },
    "exercise": {
      "title": "Quiz: CQRS Pattern",
      "timeLimit": 15,
      "questions": [
        {
          "id": 1,
          "question": "In CQRS, what should a Command handler return?",
          "options": [
            "The updated entity after the change",
            "A success/failure status or nothing — commands should not return query data",
            "The new aggregate state for the client to cache",
            "A list of events that were produced"
          ],
          "correct": 1,
          "explanation": "Commands change state but should not return domain data — mixing mutation and query (the violation of Command-Query Separation) makes caching and scaling harder. Return only a correlation ID or success/error status; use a separate query to read the updated state."
        },
        {
          "id": 2,
          "question": "What is a CQRS read model projection?",
          "options": [
            "A database view created from SQL joins",
            "A denormalised data structure built and maintained by processing events — optimised for specific query patterns, independent of the write model's schema",
            "A cached version of the write model's data",
            "A GraphQL schema that describes available queries"
          ],
          "correct": 1,
          "explanation": "A projection listens to domain events and builds a purpose-built read model. A 'CourseEnrollmentStats' projection might store { courseId, title, studentCount, avgProgress } — computed from individual events — making the dashboard query a single table lookup instead of a complex join."
        },
        {
          "id": 3,
          "question": "What consistency model does CQRS typically provide between writes and reads?",
          "options": [
            "Strong consistency — reads always reflect the latest write",
            "Eventual consistency — the read model is updated asynchronously after a command, so there may be a brief period where reads return stale data",
            "Read-your-writes consistency only",
            "Causal consistency across all operations"
          ],
          "correct": 1,
          "explanation": "Read model projections are updated asynchronously (via event handlers or message consumers). There is a window — typically milliseconds — between a command being processed and the read model reflecting the change. UIs handle this with optimistic updates."
        }
      ]
    }
  },
  {
    "title": "Distributed Systems: CAP Theorem, Sagas & Resilience Patterns",
    "duration": "85 min", "videoUrl": "",
    "description": "Design systems that degrade gracefully under failure.",
    "notes": {
      "overview": "Distributed systems face fundamental tradeoffs formalised in the CAP Theorem: a distributed system can guarantee at most two of Consistency, Availability, and Partition Tolerance. In practice, partition tolerance is not optional (networks do fail), so the real choice is CP (consistent, potentially unavailable during partitions) vs AP (available but possibly stale during partitions).",
      "keyPoints": [
        "CAP Theorem: Consistency (every read reflects the latest write), Availability (every request gets a response), Partition Tolerance (system works despite network splits) — only two are achievable simultaneously",
        "BASE (Basically Available, Soft state, Eventually consistent) is the alternative to ACID for distributed systems that choose AP",
        "The Saga pattern handles distributed transactions across services: a sequence of local transactions, each publishing an event; compensating transactions undo completed steps on failure",
        "Bulkhead pattern isolates failures: dedicate separate thread pools or connection limits per downstream dependency so one slow service cannot exhaust shared resources",
        "Timeouts + retries with exponential backoff + jitter prevents thundering herds when a service recovers"
      ],
      "codeExample": "// Saga pattern — choreography-based\n// Each service listens to events and publishes the next event\n\n// Step 1: EnrollmentService\non(EnrollmentRequested, async (event) => {\n  await createEnrollment(event); // local transaction\n  publish(PaymentRequested, { enrollmentId: event.id, amount: course.price });\n});\n\n// Step 2: PaymentService\non(PaymentRequested, async (event) => {\n  const ok = await chargeCard(event);\n  if (ok) publish(PaymentCompleted, event);\n  else publish(PaymentFailed, event);  // triggers compensation\n});\n\n// Compensation — undo enrollment on payment failure\non(PaymentFailed, async (event) => {\n  await cancelEnrollment(event.enrollmentId);\n  publish(EnrollmentCancelled, event);\n});",
      "deepDive": "The Saga pattern does not provide ACID isolation across services — during execution, other services see intermediate state (the enrollment exists but payment hasn't completed). This is acceptable for most business workflows but requires careful design of compensating transactions. Choreography (event-driven sagas) is simpler to implement but harder to observe; Orchestration (a central saga orchestrator) is easier to debug but introduces a single point of coordination.",
      "summary": "Distributed systems require accepting inevitable trade-offs between consistency and availability — design for the failure modes you can tolerate, not the perfect-world scenario."
    },
    "exercise": {
      "title": "Quiz: Distributed Systems Fundamentals",
      "timeLimit": 17,
      "questions": [
        {
          "id": 1,
          "question": "According to the CAP Theorem, which two properties does a CP system guarantee?",
          "options": [
            "Consistency and Availability",
            "Consistency and Partition Tolerance — it may return errors during a network partition rather than serve stale data",
            "Availability and Partition Tolerance",
            "All three during normal operation"
          ],
          "correct": 1,
          "explanation": "A CP system (like HBase, Zookeeper) chooses to return an error rather than serve potentially stale data during a network partition. An AP system (like Cassandra, CouchDB) returns the best available (possibly stale) data and remains available during partitions."
        },
        {
          "id": 2,
          "question": "What is the purpose of compensating transactions in the Saga pattern?",
          "options": [
            "To optimise database performance across services",
            "To undo the effects of previously completed local transactions when a later step in the saga fails — restoring the system to a consistent state",
            "To replicate data between services",
            "To ensure messages are delivered exactly once"
          ],
          "correct": 1,
          "explanation": "Sagas cannot lock resources across services like a 2PC transaction. Instead, each step has a corresponding compensating transaction (refundPayment for chargeCard, cancelEnrollment for createEnrollment) that is triggered when a downstream step fails."
        },
        {
          "id": 3,
          "question": "What is the Bulkhead pattern and what does it prevent?",
          "options": [
            "It prevents data loss during network partitions",
            "It isolates failures by dedicating separate resource pools (threads, connections) per dependency — preventing one slow service from exhausting shared resources and failing the entire system",
            "It provides a secondary database for read replicas",
            "It routes traffic away from failed nodes"
          ],
          "correct": 1,
          "explanation": "Named after ship bulkheads (watertight compartments), the pattern limits blast radius. If the Payments service is slow and you share one thread pool, all threads block on Payments calls — starving Courses API calls. Separate thread pools mean a Payment timeout only affects Payment calls."
        }
      ]
    }
  },
  {
    "title": "Architecture Decision Records & Fitness Functions",
    "duration": "60 min", "videoUrl": "",
    "description": "Document decisions and automate architectural tests.",
    "notes": {
      "overview": "Architecture Decision Records (ADRs) are short documents capturing significant architectural decisions: the context, the options considered, the decision made, and the consequences. Fitness Functions are automated tests that verify the architecture remains compliant with its intended structure as the codebase evolves — the equivalent of unit tests for architecture.",
      "keyPoints": [
        "An ADR captures: title, status (proposed/accepted/deprecated), context, decision, and consequences — all decisions that are hard to reverse deserve an ADR",
        "ADRs are stored in the repository (docs/decisions/) and evolve: a superseded ADR is updated to 'deprecated', not deleted",
        "Fitness functions use tools like ArchUnit (Java), Dependency Cruiser (Node), or custom CI scripts to enforce rules: 'the domain layer must not import from the infrastructure layer'",
        "Evolutionary Architecture: design systems to tolerate change through guided evolution with fitness functions that protect key structural properties",
        "Document the 'why' not just the 'what' — future engineers facing the same context should understand why the decision was made, not just what it was"
      ],
      "codeExample": "# ADR-003: Use PostgreSQL instead of MongoDB\n## Status: Accepted\n## Context\nWe need a data store for course progress tracking. Initial prototype used MongoDB\nbut team lacks operational expertise and the data is highly relational.\n## Decision\nUse PostgreSQL with Supabase for managed hosting.\n## Consequences\n+ Full ACID transactions for enrollment operations\n+ Team familiar with SQL query optimisation\n+ Supabase provides auth, realtime, and storage\n- Relational schema is less flexible for unstructured lesson metadata (mitigated by JSONB)\n- Requires careful migration planning for schema changes",
      "deepDive": "The most important thing about ADRs is writing them close to when the decision is made — not 6 months later when the context is forgotten. Many teams have the inverse problem: they document what they built after the fact but not why. The 'why' — the constraints, the alternatives considered, the risks accepted — is what future engineers need most when faced with changing a system they did not build.",
      "summary": "ADRs make the invisible visible — architectural decisions are the most valuable documentation in any codebase because they explain the constraints that make the code look the way it does."
    },
    "exercise": {
      "title": "Quiz: ADRs & Fitness Functions",
      "timeLimit": 12,
      "questions": [
        {
          "id": 1,
          "question": "What should an Architecture Decision Record (ADR) capture?",
          "options": [
            "Every code review comment and technical discussion",
            "The context, options considered, decision made, and consequences — for architecturally significant decisions that are hard to reverse",
            "Meeting notes from architecture review sessions",
            "The API specification of the decided component"
          ],
          "correct": 1,
          "explanation": "ADRs focus on the WHY of significant decisions: what context made this choice necessary, what alternatives were considered and why they were rejected, and what the consequences (positive and negative) are. They are not meeting minutes — they are permanent decision artefacts."
        },
        {
          "id": 2,
          "question": "What is an architectural fitness function?",
          "options": [
            "A performance benchmark for microservices",
            "An automated test or metric that verifies the system continues to comply with a structural architectural property as it evolves",
            "A function that evaluates the ROI of architectural decisions",
            "A load test that measures system fitness under peak traffic"
          ],
          "correct": 1,
          "explanation": "Fitness functions are the architectural equivalent of unit tests. Example: a dependency-cruiser rule that fails the CI build if any file in src/domain/ imports from src/infrastructure/ — automatically enforcing the Dependency Rule on every pull request."
        },
        {
          "id": 3,
          "question": "When an ADR's decision is superseded by a newer decision, what should happen to the original ADR?",
          "options": [
            "Delete it — stale decisions create confusion",
            "Update its status to 'deprecated' or 'superseded by ADR-XXX' and keep it — the history of why previous decisions were made is valuable context",
            "Move it to a separate archive folder outside the repository",
            "Add a warning comment but otherwise leave it unchanged"
          ],
          "correct": 1,
          "explanation": "ADRs are immutable records of what was decided and why at a point in time. Marking one as superseded (not deleting it) preserves the evolution of thinking — future engineers can see that PostgreSQL replaced MongoDB and read both the original rationale and the new rationale."
        }
      ]
    }
  }
]
$sa$::jsonb
WHERE title = 'Software Architecture & Design Patterns';

COMMIT;
