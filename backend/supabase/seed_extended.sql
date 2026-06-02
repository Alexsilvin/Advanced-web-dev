-- ============================================================
--  EduSkills Portal — Extended Seed Script v2.0
-- ============================================================
--  Run this in the Supabase SQL Editor AFTER schema.sql.
--  Safe to run on a fresh database OR one already seeded with
--  the basic 8 courses from the Node.js seed route.
--
--  What this script adds
--  ─────────────────────
--    5  instructors with real bios & avatars
--   10  students with realistic African profiles
--    5  new courses with 13–16 real lectures each
--       • Advanced Web Development
--       • Data Science & Machine Learning
--       • Software Architecture & Design Patterns
--       • Software Verification & Validation
--       • Advanced Database Systems
--   35  enrollments spread across 9 months with genuine
--       progress data — feeds the analytics chart
--    ↑  existing 8 courses re-linked to real instructors
--
--  Demo password for every seeded account: Demo@2024
--  (hashed with pgcrypto blowfish, compatible with bcryptjs)
-- ============================================================

BEGIN;

-- pgcrypto gives us the crypt() function for bcrypt hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  -- ── Instructors ──────────────────────────────────────────
  v_sarah   UUID;   -- Dr. Sarah Mitchell    (Web Dev)
  v_james   UUID;   -- Prof. James Okafor   (Data Science)
  v_elena   UUID;   -- Dr. Elena Vasquez    (Architecture)
  v_michael UUID;   -- Dr. Michael Chen     (V&V / QA)
  v_amara   UUID;   -- Prof. Amara Diallo   (Databases)

  -- ── Students ─────────────────────────────────────────────
  v_s1  UUID;  v_s2  UUID;  v_s3  UUID;  v_s4  UUID;  v_s5  UUID;
  v_s6  UUID;  v_s7  UUID;  v_s8  UUID;  v_s9  UUID;  v_s10 UUID;

  -- ── New courses ───────────────────────────────────────────
  v_c_awd  UUID;   -- Advanced Web Development
  v_c_ds   UUID;   -- Data Science & Machine Learning
  v_c_sa   UUID;   -- Software Architecture & Design Patterns
  v_c_vv   UUID;   -- Software Verification & Validation
  v_c_adb  UUID;   -- Advanced Database Systems

BEGIN

-- ================================================================
--  1. INSTRUCTORS
-- ================================================================

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Dr. Sarah Mitchell',
    'sarah.mitchell@eduskills.edu',
    crypt('Demo@2024', gen_salt('bf', 10)),
    'instructor',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah-mitchell',
    'Senior Full-Stack Engineer with 12+ years at Google and Netflix. '
    'PhD in Computer Science from MIT. Specialises in modern JavaScript '
    'ecosystems, React internals, and scalable web architecture. '
    'Author of "Production React" (O''Reilly, 2023) and maintainer of '
    'three widely-used open-source libraries with 40 k+ GitHub stars.'
  ) RETURNING id INTO v_sarah;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Prof. James Okafor',
    'james.okafor@eduskills.edu',
    crypt('Demo@2024', gen_salt('bf', 10)),
    'instructor',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=james-okafor',
    'Principal Data Scientist at AfriTech Labs and visiting professor '
    'at the University of Lagos. MSc Statistics (UCT), PhD candidate in '
    'Machine Learning (Cambridge). Pioneer of the Open Data Africa '
    'initiative with 9 years in predictive analytics and NLP. '
    'Kaggle Grandmaster, top 0.1 % worldwide.'
  ) RETURNING id INTO v_james;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Dr. Elena Vasquez',
    'elena.vasquez@eduskills.edu',
    crypt('Demo@2024', gen_salt('bf', 10)),
    'instructor',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=elena-vasquez',
    'Software Architect at Amazon Web Services with 15 years designing '
    'distributed systems at global scale. PhD in Software Engineering '
    'from ETH Zurich. IEEE senior member and contributor to the CNCF '
    '(Cloud Native Computing Foundation). Keynote speaker at QCon, '
    'DDD Europe, and KubeCon.'
  ) RETURNING id INTO v_elena;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Dr. Michael Chen',
    'michael.chen@eduskills.edu',
    crypt('Demo@2024', gen_salt('bf', 10)),
    'instructor',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=michael-chen',
    'Lead QA Architect at Microsoft with expertise in formal verification, '
    'automated testing frameworks, and software quality metrics. PhD in '
    'Formal Methods from Carnegie Mellon. Certified ISTQB Expert-level '
    'and author of three peer-reviewed papers on mutation testing and '
    'property-based testing in large-scale systems.'
  ) RETURNING id INTO v_michael;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Prof. Amara Diallo',
    'amara.diallo@eduskills.edu',
    crypt('Demo@2024', gen_salt('bf', 10)),
    'instructor',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=amara-diallo',
    'Professor of Database Systems at Université Cheikh Anta Diop, '
    'Dakar, and database consultant to the African Development Bank. '
    'PhD in Computer Science from Sorbonne. 20+ years designing '
    'high-performance database architectures for financial institutions, '
    'healthcare systems, and national census platforms across Africa.'
  ) RETURNING id INTO v_amara;

-- ================================================================
--  2. COURSES  (13–16 real lectures each)
-- ================================================================

  -- ────────────────────────────────────────────────────────────
  --  A. Advanced Web Development
  -- ────────────────────────────────────────────────────────────
  INSERT INTO courses (
    title, description, category, color, rating, total_students,
    instructor_id, duration, level, price, is_free, tags, lessons
  ) VALUES (
    'Advanced Web Development',
    'Take your web development skills to production level. This course '
    'dives deep into modern React patterns (hooks, concurrent mode, server '
    'components), TypeScript advanced types, Next.js 14 App Router, '
    'GraphQL with Apollo, real-time communication with WebSockets, Docker '
    'containerisation, and automated CI/CD pipelines with GitHub Actions. '
    'You will build and ship a full-stack production application complete '
    'with end-to-end tests, a CDN-backed asset pipeline, and zero-downtime '
    'deployments — exactly the workflow used at leading tech companies.',
    'IT & Software',
    '#c7d9ff',
    4.9,
    12840,
    v_sarah,
    '14 weeks',
    'Advanced',
    0,
    false,
    ARRAY['React','TypeScript','Next.js','GraphQL','Docker','CI/CD','WebSockets','Vitest','Playwright'],
    $json$[
      {
        "title": "Modern JavaScript: ES2022–2024 — Nullish Coalescing, Optional Chaining, Top-Level Await",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Deep dive into the latest ECMAScript features with practical patterns used in production codebases."
      },
      {
        "title": "TypeScript Mastery: Generics, Mapped Types, Conditional Types & Template Literal Types",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Go beyond basic TypeScript. Learn to model complex domain logic with the type system instead of runtime checks."
      },
      {
        "title": "React 18 Internals: Fiber Architecture, Reconciliation & Concurrent Mode",
        "duration": "95 min",
        "videoUrl": "",
        "description": "Understand exactly how React renders, diffs, and commits — so you can reason about performance and edge cases with confidence."
      },
      {
        "title": "Custom Hooks: Architecture, Composition Patterns & Avoiding Re-render Traps",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Design reusable hooks that encapsulate side-effects cleanly. Includes case studies: data fetching, forms, and WebSocket hooks."
      },
      {
        "title": "Next.js 14 App Router: Layouts, Loading UI, Error Boundaries & Parallel Routes",
        "duration": "100 min",
        "videoUrl": "",
        "description": "Complete walkthrough of the App Router paradigm shift — nested layouts, route groups, intercepting routes, and the new metadata API."
      },
      {
        "title": "React Server Components & Server Actions: The End of Client-State Waterfalls",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Understand when to use RSC vs Client Components, how Server Actions replace API routes for mutations, and streaming with Suspense."
      },
      {
        "title": "State Management at Scale: Zustand, Jotai, Redux Toolkit & When to Use Each",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Practical comparison of modern state libraries. Build the same feature in each to feel the trade-offs firsthand."
      },
      {
        "title": "GraphQL API Design with Apollo Server 4 & Apollo Client 3",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Design a schema-first GraphQL API, implement resolvers, handle N+1 with DataLoader, and consume it from React with normalised cache."
      },
      {
        "title": "Real-Time Features: WebSockets, Server-Sent Events & Optimistic UI Updates",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Build a real-time collaborative feature. Compare WebSockets vs SSE, implement reconnection logic, and sync server state optimistically."
      },
      {
        "title": "Web Performance: Core Web Vitals, Code Splitting, Bundle Analysis & Image Optimisation",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Measure and improve LCP, CLS, and FID. Use webpack-bundle-analyzer, dynamic imports, and next/image to hit green on PageSpeed Insights."
      },
      {
        "title": "Testing Pyramid: Unit Tests with Vitest, Component Tests with RTL & E2E with Playwright",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Build a full test suite from scratch. Learn what to test at each layer, write effective assertions, and avoid testing implementation details."
      },
      {
        "title": "Containerisation: Docker, Multi-Stage Builds & Docker Compose for Local Dev",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Containerise a Next.js + Node.js + PostgreSQL stack. Build optimised production images and wire up a local dev environment with hot reload."
      },
      {
        "title": "CI/CD with GitHub Actions: Lint, Test, Build, Preview & Production Deployment",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Automate the full release pipeline. Configure parallel jobs, environment secrets, Netlify preview deployments, and Render production releases."
      },
      {
        "title": "Capstone Project: Ship a Production Full-Stack App from Zero to Live URL",
        "duration": "120 min",
        "videoUrl": "",
        "description": "Combine every skill from the course to build and deploy a real SaaS feature: auth, data fetching, real-time updates, full test coverage, and CI/CD."
      }
    ]$json$::jsonb
  ) RETURNING id INTO v_c_awd;


  -- ────────────────────────────────────────────────────────────
  --  B. Data Science & Machine Learning
  -- ────────────────────────────────────────────────────────────
  INSERT INTO courses (
    title, description, category, color, rating, total_students,
    instructor_id, duration, level, price, is_free, tags, lessons
  ) VALUES (
    'Data Science & Machine Learning',
    'A rigorous end-to-end course covering the full data science pipeline '
    'from raw data ingestion to model deployment in production. Topics '
    'include statistical inference, supervised and unsupervised machine '
    'learning with Scikit-learn, deep learning with TensorFlow/Keras, '
    'natural language processing with Transformers, computer vision with '
    'CNNs, and building ML APIs with FastAPI and Docker. Includes 4 '
    'real-world projects and a capstone on an African agriculture dataset '
    'predicting crop yield from satellite imagery and weather data.',
    'Data Science',
    '#e0d5ff',
    4.8,
    15320,
    v_james,
    '16 weeks',
    'Intermediate',
    0,
    false,
    ARRAY['Python','Machine Learning','TensorFlow','Scikit-learn','NLP','Computer Vision','FastAPI','Pandas','MLOps'],
    $json$[
      {
        "title": "Python Scientific Stack: NumPy Arrays, Pandas DataFrames & SciPy Stats — from Beginner to Expert",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Master vectorised operations, multi-indexing, groupby patterns, and the statistical functions you will use in every project."
      },
      {
        "title": "Exploratory Data Analysis: Distribution Analysis, Correlation, Outlier Detection & Matplotlib/Seaborn Visualisation",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Develop the EDA muscle memory that separates good data scientists. Includes a full analysis of a real African population dataset."
      },
      {
        "title": "Statistical Inference: Probability Distributions, Confidence Intervals & Hypothesis Testing",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Understand p-values, Type I/II errors, t-tests, chi-square tests, and ANOVA — and when each is appropriate."
      },
      {
        "title": "Feature Engineering: Encoding Categorical Variables, Scaling, Imputation & Selection",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Transform raw data into model-ready features. Covers pipelines with sklearn, target encoding, polynomial features, and feature importance."
      },
      {
        "title": "Supervised Learning I: Linear & Logistic Regression — Theory, Assumptions & Diagnostics",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Go beyond fitting a model — interpret coefficients, check residuals, detect multicollinearity, and tune regularisation (Ridge, Lasso, Elastic Net)."
      },
      {
        "title": "Supervised Learning II: Decision Trees, Random Forests, Gradient Boosting & XGBoost",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Understand tree-based methods from first principles. Tune hyperparameters with Optuna and interpret models with SHAP values."
      },
      {
        "title": "Unsupervised Learning: K-Means, DBSCAN, Hierarchical Clustering & PCA Dimensionality Reduction",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Segment customers, detect anomalies, and compress high-dimensional data. Visualise clusters with t-SNE and UMAP."
      },
      {
        "title": "Model Evaluation: Cross-Validation, ROC/AUC, Precision-Recall, Calibration & Bias-Variance Trade-off",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Choose the right metric for every business problem and avoid the leakage and overfitting pitfalls that invalidate most Kaggle-to-production transitions."
      },
      {
        "title": "Neural Networks from Scratch: Backpropagation, Gradient Descent & Activation Functions Implemented in NumPy",
        "duration": "95 min",
        "videoUrl": "",
        "description": "Build a multilayer perceptron without any deep-learning framework so you truly understand what happens inside every epoch."
      },
      {
        "title": "Deep Learning with TensorFlow & Keras: CNNs for Image Classification & RNNs for Sequence Modelling",
        "duration": "100 min",
        "videoUrl": "",
        "description": "Build, train, and evaluate convolutional and recurrent networks. Includes transfer learning with MobileNetV3 on a custom image dataset."
      },
      {
        "title": "Natural Language Processing: Text Preprocessing, TF-IDF, Word2Vec & BERT Fine-Tuning with HuggingFace",
        "duration": "95 min",
        "videoUrl": "",
        "description": "Classify sentiment, extract named entities, and fine-tune a pre-trained Transformer on a multilingual African news corpus."
      },
      {
        "title": "Computer Vision: Object Detection with YOLOv8 & Semantic Segmentation",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Train an object detection model to identify crop disease from drone imagery — a direct application for African agriculture."
      },
      {
        "title": "Model Deployment: FastAPI REST Service, Docker Image & Cloud Deploy on Render",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Wrap your trained model in a production API with input validation, async inference, health checks, and rolling deployments."
      },
      {
        "title": "Big Data Processing with Apache Spark & PySpark: DataFrames, Spark SQL & MLlib",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Process datasets that do not fit in memory. Run distributed training jobs on a local Spark cluster and connect to cloud data lakes."
      },
      {
        "title": "MLOps: Experiment Tracking with MLflow, Model Versioning & Monitoring for Drift",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Set up a reproducible ML workflow: log every experiment, version models in a registry, and alert when production accuracy degrades."
      },
      {
        "title": "Capstone: End-to-End ML System — Crop Yield Prediction on African Agriculture Data",
        "duration": "150 min",
        "videoUrl": "",
        "description": "Build, evaluate, deploy, and monitor a full ML pipeline on a real dataset. Includes a written report suitable for a data science portfolio."
      }
    ]$json$::jsonb
  ) RETURNING id INTO v_c_ds;


  -- ────────────────────────────────────────────────────────────
  --  C. Software Architecture & Design Patterns
  -- ────────────────────────────────────────────────────────────
  INSERT INTO courses (
    title, description, category, color, rating, total_students,
    instructor_id, duration, level, price, is_free, tags, lessons
  ) VALUES (
    'Software Architecture & Design Patterns',
    'Master the principles and patterns that separate amateur code from '
    'production-grade systems. This course covers all 5 SOLID principles, '
    'all 23 Gang of Four design patterns with modern TypeScript implementations, '
    'Clean Architecture, Hexagonal Architecture, Domain-Driven Design with '
    'Bounded Contexts, Microservices decomposition, Event-Driven Architecture '
    'with Kafka, CQRS with event sourcing, and the art of writing Architecture '
    'Decision Records. Every module includes a before-and-after refactoring '
    'exercise on a real legacy codebase.',
    'IT & Software',
    '#d5ffe8',
    4.7,
    8450,
    v_elena,
    '12 weeks',
    'Advanced',
    0,
    false,
    ARRAY['Design Patterns','Clean Architecture','Microservices','DDD','CQRS','Event-Driven','SOLID','System Design','TypeScript'],
    $json$[
      {
        "title": "Why Architecture Matters: Measuring Technical Debt, Coupling & Cyclomatic Complexity",
        "duration": "60 min",
        "videoUrl": "",
        "description": "Quantify the quality of a codebase before and after refactoring using SonarQube metrics and dependency graphs."
      },
      {
        "title": "SOLID Principles in Depth: Theory, Common Violations & Refactoring Recipes",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Work through 5 real codebases that violate each SOLID principle, identify the symptoms, and apply the cure."
      },
      {
        "title": "Creational Patterns: Singleton, Factory Method, Abstract Factory, Builder & Prototype",
        "duration": "75 min",
        "videoUrl": "",
        "description": "When to use each creational pattern, their pitfalls, and modern TypeScript idioms that replace some classical implementations."
      },
      {
        "title": "Structural Patterns: Adapter, Bridge, Composite, Decorator, Facade, Flyweight & Proxy",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Compose objects and classes flexibly. Build a plugin system using the Decorator pattern and an API gateway using the Proxy pattern."
      },
      {
        "title": "Behavioural Patterns: Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Decouple algorithms from objects. Implement an event bus, undo/redo history, and a rule engine using behavioural patterns."
      },
      {
        "title": "Clean Architecture: Layers, the Dependency Rule, Use Cases & Boundaries",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Build a web application where the core business rules have zero dependencies on frameworks, databases, or HTTP."
      },
      {
        "title": "Hexagonal Architecture (Ports & Adapters): Keeping Your Domain Framework-Agnostic",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Define Ports (interfaces) that protect your domain, write Adapters for Express and PostgreSQL, and swap them for tests with in-memory fakes."
      },
      {
        "title": "Domain-Driven Design: Entities, Value Objects, Aggregates, Domain Events & Bounded Contexts",
        "duration": "95 min",
        "videoUrl": "",
        "description": "Model a real e-learning domain with DDD building blocks. Draw a context map, define anti-corruption layers, and implement domain events."
      },
      {
        "title": "Microservices: Decomposition by Business Capability, Service Mesh, API Gateway & the Strangler Fig Pattern",
        "duration": "100 min",
        "videoUrl": "",
        "description": "Break a monolith incrementally. Configure an Nginx API gateway, implement service discovery, and handle partial failure with Circuit Breakers."
      },
      {
        "title": "Event-Driven Architecture: Apache Kafka, Event Sourcing & the Outbox Pattern",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Build a reliable event pipeline. Produce and consume messages with Kafka, persist events as the source of truth, and avoid dual-write inconsistencies."
      },
      {
        "title": "CQRS: Separating Command and Query Models & Building Read-Model Projections",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Implement a write model backed by event sourcing and a read model materialised into PostgreSQL views optimised for the UI."
      },
      {
        "title": "Distributed Systems: CAP Theorem, BASE, Sagas & Resilience Patterns (Retry, Circuit Breaker, Bulkhead)",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Design systems that degrade gracefully. Implement the Saga pattern for distributed transactions and chaos-test with fault injection."
      },
      {
        "title": "Architecture Decision Records & Fitness Functions: Governing Architecture Over Time",
        "duration": "60 min",
        "videoUrl": "",
        "description": "Document decisions so future teams understand the why, and write automated architectural tests that fail when the system drifts from its intended structure."
      }
    ]$json$::jsonb
  ) RETURNING id INTO v_c_sa;


  -- ────────────────────────────────────────────────────────────
  --  D. Software Verification & Validation
  -- ────────────────────────────────────────────────────────────
  INSERT INTO courses (
    title, description, category, color, rating, total_students,
    instructor_id, duration, level, price, is_free, tags, lessons
  ) VALUES (
    'Software Verification & Validation',
    'A comprehensive course on ensuring software correctness, reliability, '
    'and safety through systematic testing and formal methods. Covers the '
    'full V&V landscape: TDD, BDD, unit and integration testing, end-to-end '
    'automation with Playwright, performance and load testing with k6, '
    'static analysis with SonarQube, mutation testing with Stryker, '
    'property-based testing, security scanning, and continuous testing in '
    'CI/CD pipelines. Aligned with ISTQB Foundation and Advanced standards.',
    'IT & Software',
    '#fff5c7',
    4.6,
    5230,
    v_michael,
    '10 weeks',
    'Intermediate',
    0,
    false,
    ARRAY['TDD','BDD','Jest','Playwright','k6','SonarQube','Mutation Testing','ISTQB','QA','Property-Based Testing'],
    $json$[
      {
        "title": "Software Quality Fundamentals: Verification vs Validation, Cost of Defects & the V-Model",
        "duration": "60 min",
        "videoUrl": "",
        "description": "Understand the full quality lifecycle: why bugs found in production cost 100× more than those found in design, and how to shift testing left."
      },
      {
        "title": "Unit Testing Mastery with Jest: Arrange-Act-Assert, Test Doubles (Mocks, Stubs, Fakes, Spies)",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Write tests that document intent, run fast, and never break on implementation changes. Distinguish what to mock vs what to test through real interfaces."
      },
      {
        "title": "Test-Driven Development (TDD): Red-Green-Refactor Discipline & the Three Laws",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Practice TDD on a full feature from scratch. See how it drives better design, smaller functions, and higher confidence when refactoring."
      },
      {
        "title": "Behaviour-Driven Development (BDD): Gherkin Scenarios, Cucumber & Living Documentation",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Write executable specifications that business stakeholders can read. Bridge the gap between requirements and automated tests."
      },
      {
        "title": "Integration Testing: Strategies, Test Containers & Database Testing Without Mocking the DB",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Spin up real PostgreSQL and Redis instances in CI with Testcontainers. Test your entire data layer against production-equivalent infrastructure."
      },
      {
        "title": "End-to-End & UI Testing with Playwright: Page Object Model, Visual Regression & Cross-Browser",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Automate critical user journeys in Chromium, Firefox, and WebKit. Intercept API calls, record traces, and debug failures with the Playwright Inspector."
      },
      {
        "title": "Performance & Load Testing with k6: Scripting Scenarios, SLOs, Thresholds & Bottleneck Analysis",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Define and enforce Service Level Objectives. Run ramp-up, stress, and soak tests, and read flame graphs to find the slow query or the memory leak."
      },
      {
        "title": "Static Analysis & Code Quality: ESLint, TypeScript Strict Mode, SonarQube & Technical Debt Remediation",
        "duration": "65 min",
        "videoUrl": "",
        "description": "Configure quality gates in CI that block merges when coverage drops, security hotspots appear, or code smell thresholds are breached."
      },
      {
        "title": "Mutation Testing with Stryker: Measuring the Effectiveness of Your Test Suite",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Stop measuring coverage and start measuring kill rate. Discover the untested logic branches that code coverage silently ignores."
      },
      {
        "title": "Property-Based Testing with fast-check: Generating Thousands of Test Cases Automatically",
        "duration": "65 min",
        "videoUrl": "",
        "description": "Define invariants and let the framework break them. Find edge cases in parsers, algorithms, and data transformations you would never think to write manually."
      },
      {
        "title": "Security Testing: OWASP ZAP for DAST, npm audit, Snyk & Dependency Vulnerability Scanning",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Integrate security scans into the CI pipeline. Run automated DAST against a staging environment and block deploys when critical CVEs are detected."
      },
      {
        "title": "Continuous Testing in CI/CD: Test Parallelisation, Flaky Test Management & Reporting Dashboards",
        "duration": "65 min",
        "videoUrl": "",
        "description": "Keep your test suite fast and reliable at scale. Shard tests across 10 runners, quarantine flakes, and publish results to a Grafana dashboard."
      },
      {
        "title": "Capstone: Build a Complete Quality Gate for a Real Open-Source Node.js Project",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Fork an unmaintained open-source project, audit its quality, add unit + integration + E2E tests, configure SonarQube, and open a real pull request."
      }
    ]$json$::jsonb
  ) RETURNING id INTO v_c_vv;


  -- ────────────────────────────────────────────────────────────
  --  E. Advanced Database Systems
  -- ────────────────────────────────────────────────────────────
  INSERT INTO courses (
    title, description, category, color, rating, total_students,
    instructor_id, duration, level, price, is_free, tags, lessons
  ) VALUES (
    'Advanced Database Systems',
    'Go far beyond basic SQL. This course covers relational theory, '
    'advanced PostgreSQL features (window functions, recursive CTEs, '
    'full-text search, JSONB, table partitioning), deep query optimisation '
    'and execution plan analysis with EXPLAIN ANALYSE, all major indexing '
    'strategies, ACID transactions and MVCC isolation levels, streaming '
    'replication and high availability, NoSQL systems (MongoDB aggregation '
    'pipeline, Redis data structures, Cassandra wide-column model), '
    'distributed SQL, time-series databases, and data warehousing with dbt. '
    'Capstone: design the complete database layer for a 10-million-user SaaS.',
    'IT & Software',
    '#ffc7e0',
    4.8,
    7890,
    v_amara,
    '12 weeks',
    'Advanced',
    0,
    false,
    ARRAY['PostgreSQL','SQL','NoSQL','MongoDB','Redis','Query Optimisation','Indexing','Replication','Data Warehousing','dbt','Cassandra'],
    $json$[
      {
        "title": "Relational Theory Revisited: Functional Dependencies, Normal Forms 1NF–BCNF & Safe Decomposition",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Understand why normalisation rules exist — not as dogma but as proofs that certain anomalies cannot occur in your schema."
      },
      {
        "title": "Advanced SQL I: Window Functions — PARTITION BY, ORDER BY, ROWS/RANGE, LAG, LEAD, NTILE & PERCENT_RANK",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Write analytical queries that would require multiple self-joins or application-layer logic. Solve 12 real business intelligence challenges."
      },
      {
        "title": "Advanced SQL II: Recursive CTEs, Lateral Joins, FILTER Clause, GROUPING SETS & ROLLUP",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Traverse trees and graphs inside the database, join functions that depend on outer row values, and generate pivot tables in pure SQL."
      },
      {
        "title": "PostgreSQL Advanced Features: Full-Text Search, JSONB Operators, Array Types & Generated Columns",
        "duration": "75 min",
        "videoUrl": "",
        "description": "Replace Elasticsearch for most use cases with PostgreSQL FTS. Store and query semi-structured data in JSONB with GIN indexes."
      },
      {
        "title": "Query Optimisation Deep Dive: EXPLAIN ANALYSE, Planner Cost Model, Statistics & the VACUUM Process",
        "duration": "90 min",
        "videoUrl": "",
        "description": "Read and interpret execution plans. Identify sequential scans, bad cardinality estimates, and nested-loop traps — then fix them."
      },
      {
        "title": "Indexing Strategies: B-Tree, Hash, GIN, GiST, BRIN, Partial Indexes & Index-Only Scans",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Choose the right index type for every access pattern. Measure the write amplification trade-off and know when not to index."
      },
      {
        "title": "Transactions Deep Dive: ACID Properties, MVCC Implementation, Isolation Levels & Lock Types",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Understand Read Committed vs Repeatable Read vs Serialisable. Reproduce phantom reads, write skew, and serialisation failures — then prevent them."
      },
      {
        "title": "PostgreSQL Storage Internals: Table Pages, TOAST, Bloat & Partitioning (Range, List, Hash)",
        "duration": "75 min",
        "videoUrl": "",
        "description": "See how Postgres stores rows on disk. Partition a billion-row audit log table and watch query times drop from minutes to milliseconds."
      },
      {
        "title": "High Availability: Streaming Replication, Logical Replication, Patroni Failover & Connection Pooling with PgBouncer",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Set up a primary + two replica cluster with automatic failover. Implement read-scaling and zero-downtime schema migrations with pgroll."
      },
      {
        "title": "NoSQL Deep Dive: MongoDB Aggregation Pipeline, Redis Data Structures & Cassandra Wide-Column Model",
        "duration": "95 min",
        "videoUrl": "",
        "description": "Implement the same feature (leaderboard, session store, event log) in three NoSQL systems and compare consistency, latency, and operational complexity."
      },
      {
        "title": "Sharding, Horizontal Scaling & Distributed SQL: Citus for PostgreSQL & CockroachDB",
        "duration": "80 min",
        "videoUrl": "",
        "description": "Distribute a multi-tenant SaaS database across shards. Route tenant traffic, rebalance shards online, and benchmark distributed transactions."
      },
      {
        "title": "Time-Series Databases: TimescaleDB Hypertables, Continuous Aggregates & InfluxDB for IoT Metrics",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Ingest 100 k sensor readings per second without table bloat. Query time-bucketed aggregates in milliseconds with materialised continuous aggregates."
      },
      {
        "title": "Data Warehousing: Star Schema, dbt Transformations, Columnar Storage & OLAP Query Patterns",
        "duration": "85 min",
        "videoUrl": "",
        "description": "Build a dimensional model from an operational PostgreSQL database. Transform raw events into fact and dimension tables using dbt and query them analytically."
      },
      {
        "title": "Database Security: Row-Level Security Policies, Column Encryption, Audit Logging & GDPR Data Erasure",
        "duration": "70 min",
        "videoUrl": "",
        "description": "Implement multi-tenant RLS so users can only see their own rows. Encrypt PII columns with pgcrypto and design a GDPR-compliant right-to-erasure procedure."
      },
      {
        "title": "Capstone: Design the Database Layer for a 10-Million-User SaaS Application",
        "duration": "120 min",
        "videoUrl": "",
        "description": "Starting from requirements, produce a full schema design document: ERD, normalisation decisions, index plan, partitioning strategy, replication topology, and migration plan."
      }
    ]$json$::jsonb
  ) RETURNING id INTO v_c_adb;


-- ================================================================
--  3. STUDENTS — 10 realistic African profiles
-- ================================================================

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Kofi Mensah', 'kofi.mensah@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=kofi-mensah',
    'Software engineering student at KNUST, Ghana, in his final year. '
    'Passionate about backend systems and distributed computing. '
    'Interning at a Accra-based fintech startup. Wants to build the '
    'infrastructure layer for the next generation of African payment systems.'
  ) RETURNING id INTO v_s1;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Amina Traore', 'amina.traore@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=amina-traore',
    'Data analyst at a Nairobi-based conservation NGO, transitioning '
    'into a full data scientist role. Background in statistics and R. '
    'Enrolled in 4 courses to accelerate her career change into ML. '
    'Wants to apply predictive modelling to wildlife anti-poaching data.'
  ) RETURNING id INTO v_s2;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Chidi Okonkwo', 'chidi.okonkwo@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=chidi-okonkwo',
    'Full-stack developer with 3 years of experience at a Lagos agency, '
    'looking to level up in architecture and DevOps. Contributor to '
    'several open-source projects on GitHub. Goal: move from feature '
    'developer to the principal engineer responsible for system design.'
  ) RETURNING id INTO v_s3;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Fatima Al-Hassan', 'fatima.alhassan@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=fatima-alhassan',
    'Postgraduate student in Information Systems at Cairo University. '
    'Research focus: database performance tuning for large-scale '
    'government data platforms serving millions of citizens. '
    'Recipient of the African Digital Futures scholarship 2024.'
  ) RETURNING id INTO v_s4;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Lerato Dlamini', 'lerato.dlamini@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=lerato-dlamini',
    'Junior QA engineer at a South African healthtech startup. '
    'Self-taught programmer determined to master formal V&V methodologies '
    'and build a culture of quality on her 8-person engineering team. '
    'Advocates for accessibility testing as a first-class quality concern.'
  ) RETURNING id INTO v_s5;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Yusuf Ibrahim', 'yusuf.ibrahim@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=yusuf-ibrahim',
    'Freelance web developer from Abuja, Nigeria, building digital tools '
    'for SMEs that cannot afford agency rates. Currently upskilling in '
    'React and Next.js to offer modern JAMstack solutions. '
    'Runs a weekly coding club for secondary school students in his community.'
  ) RETURNING id INTO v_s6;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Miriam Njoroge', 'miriam.njoroge@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=miriam-njoroge',
    'Product manager at a Kenyan edtech startup, pivoting into engineering. '
    'Studying software architecture to collaborate more effectively with '
    'her team and take ownership of technical product decisions. '
    'Organiser of the Nairobi Women in Tech monthly meetup.'
  ) RETURNING id INTO v_s7;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Oumar Balde', 'oumar.balde@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=oumar-balde',
    'Computer science undergraduate at Université Cheikh Anta Diop, Dakar. '
    'Interested in ML applications for agriculture and climate modelling '
    'in the Sahel. Research assistant at the CIRAD lab studying '
    'remote-sensing data for crop monitoring in West Africa.'
  ) RETURNING id INTO v_s8;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Nadia Boateng', 'nadia.boateng@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=nadia-boateng',
    'Backend engineer at a Ghanaian payments company handling 2 M+ '
    'transactions per day. Deep interest in database internals and query '
    'optimisation. Aiming to become the resident database reliability '
    'engineer and reduce P99 latency on the payments audit trail from 800 ms to under 50 ms.'
  ) RETURNING id INTO v_s9;

  INSERT INTO users (name, email, password_hash, role, avatar, bio)
  VALUES (
    'Emmanuel Mwangi', 'emmanuel.mwangi@student.edu',
    crypt('Demo@2024', gen_salt('bf', 10)), 'student',
    'https://api.dicebear.com/7.x/avataaars/svg?seed=emmanuel-mwangi',
    'IT officer at a Nairobi county government office, studying to '
    'modernise public-sector software infrastructure. First-generation '
    'university graduate, passionate about applying technology to improve '
    'civic services. Working towards a solution for digitising land records.'
  ) RETURNING id INTO v_s10;


-- ================================================================
--  4. ENROLLMENTS — spread across 9 months, realistic progress
--     (these feed the analytics / activity chart in the dashboard)
-- ================================================================

  -- ── Kofi Mensah — strong in AWD, mid-way in Data Science ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s1, v_c_awd, 86,
    '[0,1,2,3,4,5,6,7,8,9,10,11]'::jsonb,
    NOW() - INTERVAL '5 months', NOW() - INTERVAL '2 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s1, v_c_ds, 44,
    '[0,1,2,3,4,5,6]'::jsonb,
    NOW() - INTERVAL '2 months', NOW() - INTERVAL '1 day');

  -- ── Amina Traore — near-complete in DS, started AWD and DB ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s2, v_c_ds, 94,
    '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]'::jsonb,
    NOW() - INTERVAL '7 months', NOW() - INTERVAL '3 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s2, v_c_awd, 21,
    '[0,1,2]'::jsonb,
    NOW() - INTERVAL '1 month', NOW() - INTERVAL '4 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s2, v_c_adb, 13,
    '[0,1]'::jsonb,
    NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '1 day');

  -- ── Chidi Okonkwo — Architecture complete, AWD mid, V&V mid ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s3, v_c_sa, 100,
    '[0,1,2,3,4,5,6,7,8,9,10,11,12]'::jsonb,
    NOW() - INTERVAL '8 months', NOW() - INTERVAL '10 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s3, v_c_awd, 57,
    '[0,1,2,3,4,5,6,7]'::jsonb,
    NOW() - INTERVAL '3 months', NOW() - INTERVAL '1 day');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s3, v_c_vv, 46,
    '[0,1,2,3,4,5]'::jsonb,
    NOW() - INTERVAL '2 months', NOW() - INTERVAL '2 days');

  -- ── Fatima Al-Hassan — deep in Advanced DB, started Architecture ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s4, v_c_adb, 73,
    '[0,1,2,3,4,5,6,7,8,9,10]'::jsonb,
    NOW() - INTERVAL '6 months', NOW() - INTERVAL '1 day');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s4, v_c_sa, 31,
    '[0,1,2,3]'::jsonb,
    NOW() - INTERVAL '5 weeks', NOW() - INTERVAL '3 days');

  -- ── Lerato Dlamini — near-complete in V&V, just started AWD ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s5, v_c_vv, 92,
    '[0,1,2,3,4,5,6,7,8,9,10,11]'::jsonb,
    NOW() - INTERVAL '4 months', NOW() - INTERVAL '5 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s5, v_c_awd, 14,
    '[0,1]'::jsonb,
    NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '2 days');

  -- ── Yusuf Ibrahim — mid-way in AWD, early in V&V ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s6, v_c_awd, 64,
    '[0,1,2,3,4,5,6,7,8]'::jsonb,
    NOW() - INTERVAL '4 months', NOW() - INTERVAL '1 day');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s6, v_c_vv, 23,
    '[0,1,2]'::jsonb,
    NOW() - INTERVAL '5 weeks', NOW() - INTERVAL '3 days');

  -- ── Miriam Njoroge — mid-way in Architecture, just started V&V ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s7, v_c_sa, 62,
    '[0,1,2,3,4,5,6,7]'::jsonb,
    NOW() - INTERVAL '5 months', NOW() - INTERVAL '2 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s7, v_c_vv, 8,
    '[0]'::jsonb,
    NOW() - INTERVAL '3 weeks', NOW() - INTERVAL '6 days');

  -- ── Oumar Balde — nearly done with DS, just opened Advanced DB ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s8, v_c_ds, 81,
    '[0,1,2,3,4,5,6,7,8,9,10,11,12]'::jsonb,
    NOW() - INTERVAL '6 months', NOW() - INTERVAL '1 day');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s8, v_c_adb, 7,
    '[0]'::jsonb,
    NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '4 days');

  -- ── Nadia Boateng — Advanced DB COMPLETE, mid-way in Architecture ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s9, v_c_adb, 100,
    '[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14]'::jsonb,
    NOW() - INTERVAL '9 months', NOW() - INTERVAL '15 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s9, v_c_sa, 54,
    '[0,1,2,3,4,5,6]'::jsonb,
    NOW() - INTERVAL '3 months', NOW() - INTERVAL '1 day');

  -- ── Emmanuel Mwangi — early stages in AWD and Data Science ──
  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s10, v_c_awd, 29,
    '[0,1,2,3]'::jsonb,
    NOW() - INTERVAL '6 weeks', NOW() - INTERVAL '2 days');

  INSERT INTO enrollments (user_id, course_id, progress, completed_lessons, enrolled_at, last_accessed)
  VALUES (v_s10, v_c_ds, 6,
    '[0]'::jsonb,
    NOW() - INTERVAL '2 weeks', NOW() - INTERVAL '1 day');


-- ================================================================
--  5. UPDATE EXISTING COURSES — link to real instructors
--     (the Node.js seed inserted them with instructor_id = NULL)
-- ================================================================

  UPDATE courses SET instructor_id = v_james
  WHERE title = 'Python for Data Analysis';

  UPDATE courses SET instructor_id = v_sarah
  WHERE title IN ('Web Development Bootcamp', 'Cloud Computing Basics');

  UPDATE courses SET instructor_id = v_amara
  WHERE title = 'Advanced Database Systems';  -- in case it was re-seeded

  UPDATE courses SET instructor_id = v_elena
  WHERE title IN ('Digital Citizenship & Online Safety', 'UI/UX Design Fundamentals');

  UPDATE courses SET instructor_id = v_james
  WHERE title IN ('Digital Marketing Fundamentals', 'Financial Literacy for Entrepreneurs');

  UPDATE courses SET instructor_id = v_michael
  WHERE title = 'Entrepreneurship 101';

END $$;

COMMIT;


-- ================================================================
--  ANALYTICS VIEWS — run these after the DO block commits
--  They power future dashboard enhancements.
-- ================================================================

-- Per-course enrollment statistics
CREATE OR REPLACE VIEW v_course_stats AS
SELECT
  c.id,
  c.title,
  c.category,
  c.rating,
  c.total_students,
  COUNT(e.id)                                           AS enrolled_count,
  ROUND(AVG(e.progress), 1)                            AS avg_progress,
  COUNT(e.id) FILTER (WHERE e.progress = 100)          AS completed_count,
  COUNT(e.id) FILTER (WHERE e.progress > 0
                       AND  e.progress < 100)          AS in_progress_count,
  COUNT(e.id) FILTER (WHERE e.progress = 0)            AS not_started_count,
  MIN(e.enrolled_at)                                   AS first_enrollment,
  MAX(e.last_accessed)                                 AS last_activity
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.title, c.category, c.rating, c.total_students;

-- Monthly enrollment trend (last 12 months)
CREATE OR REPLACE VIEW v_monthly_enrollments AS
SELECT
  DATE_TRUNC('month', enrolled_at)  AS month,
  COUNT(*)                           AS new_enrollments,
  COUNT(*) FILTER (WHERE progress = 100) AS completions
FROM enrollments
WHERE enrolled_at >= NOW() - INTERVAL '12 months'
GROUP BY DATE_TRUNC('month', enrolled_at)
ORDER BY month;

-- Per-student learning summary
CREATE OR REPLACE VIEW v_student_summary AS
SELECT
  u.id,
  u.name,
  u.email,
  u.avatar,
  COUNT(e.id)                                           AS courses_enrolled,
  COUNT(e.id) FILTER (WHERE e.progress = 100)          AS courses_completed,
  ROUND(AVG(e.progress), 1)                            AS avg_progress,
  MAX(e.last_accessed)                                 AS last_seen,
  SUM(
    jsonb_array_length(e.completed_lessons)
  )                                                    AS total_lessons_done
FROM users u
LEFT JOIN enrollments e ON e.user_id = u.id
WHERE u.role = 'student'
GROUP BY u.id, u.name, u.email, u.avatar;

-- Category popularity breakdown
CREATE OR REPLACE VIEW v_category_stats AS
SELECT
  c.category,
  COUNT(DISTINCT c.id)                   AS course_count,
  SUM(c.total_students)                  AS total_students,
  ROUND(AVG(c.rating), 2)               AS avg_rating,
  COUNT(e.id)                            AS total_enrollments,
  ROUND(AVG(e.progress), 1)             AS avg_student_progress
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.category
ORDER BY total_enrollments DESC;


-- ================================================================
--  QUICK VERIFICATION QUERY
--  Run this to confirm everything was inserted correctly.
-- ================================================================
/*
SELECT
  (SELECT COUNT(*) FROM users WHERE role = 'instructor') AS instructors,
  (SELECT COUNT(*) FROM users WHERE role = 'student')    AS students,
  (SELECT COUNT(*) FROM courses)                         AS total_courses,
  (SELECT COUNT(*) FROM enrollments)                     AS total_enrollments;

-- Expected:
--   instructors | students | total_courses | total_enrollments
--       5       |    10    |      13       |        35
*/
