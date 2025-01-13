# Intro

## AI Workload & Ethics

- Responsible AI MSFT Standard - 6 key principles for Responsible AI
  - Fairness - no bias *or* lack of quality for all groups
  - Reliability / Safety - on going monitoring / failure checking
  - Privacy - data is treated in a compliant way
  - Inclusiveness - accessibility
  - Transparency - keeping users informed on AI limits and understanding of the tool
  - Accountability - keeping developers accountable for AI actions. Also means putting in place procedures that allow humans to intervene and override the decisions made by AI systems. 

### Common Workloads

1. Machine Learning (Subset of AI)
2. Computer Vision
3. Language

and many more.

### Single Resource Vs Multi Resource

In the Single Resource model costs are shown separately, where as in the multi-resource model they are not. In the latter method, access is done via a single endpoint and key. You may access services via
- Studio Interfaces
- API
- SDK

The resources are protected by a resource key much like a storage account.

### Common ML Concepts

#### Process
1. Data Collection and splitting of Data into training, validation, and test.
2. Model Training
3. Making Predictions

#### Techniques

![techniques](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxdm0c7jLBRmndBqHspvwQTNIkFUQUf71JPQ&s)

**Examples**
- Regression: Predicting odds of some event occuring based on past data
- Classification: Output the correct *class* based on traing data. Example: Which animal is this image of?
- Clustering: This method helps group data as in this method the *answer* is not known at the time of training.


**Deep Learning**: This is a class of ML in which training occurs in a number of complex layers which automates feature extraction but requires a larger initial data set. This is more suitable for tasks like NLP or Speech Recoginition. 

#### Azure AI Capabilities

- Automated ML: automates the creation of models to aid those who may not know a lot about machine learning / coding. Supports
  - Classification, Regression, Time-Series, CV, NLP
  - Building and Deployment of Models
  - Easy Data Exploration
- Designer - Drag and Drop to build ML pipelines visually
- Compute Services - Controls the target environment where you wish to run your training scripts or hosting your deployment.
  - They can be reused
- Data Services - controls the data you can use in your AI workloads. They are a reference to a Azure Storage Account
- Model Management - MLOps Services
- Deployments - Handled by the endpoints assets. This also provides authn/authz. A single endpoint can interface with many deployments.




# CV

> Computer Vision

## Examples

1. Image Classification
2. Object Detection
   - A Model is able to identity types of objects with some confidence level (Probablity Score) and a bounding box which can help locate it on the image.
3. Optical Char Recog
   - Process words in images into selectable text.
4. Facial Detection / Facial Analysis
   - Locates human faces and important facial landmarks,

While object and image detection may seem the same, Image classification is used when the focus is one object such as accessing when something is a cat vs a dog.

## Services

> All are prefixed with "Azure"

- AI Vision (pre-trained models)
  - Image Analysis Tasks: Classification, Object Detection, Caption Generation
  - Spatial Analysis: People Presense, Video Summary, Detect People
  - OCR
  - Face Recog
- AI Custom Vision
  - Allow you to build your own Models for: classification / object detection
- AI Face Services
  - Liveness (determine a face in a video stream is real)
  - Face Recog - Uses the 2 below services
  - Identification: One to many matching of a subject face in a secure repo
  - Verification: 1:1 matching of a subject face.
- AI Video Indexer
  - uses AI to find insights of a video
  - can be used for
    - Deep Search
    - Content Creation
    - Content Moderation


# NLP

## Senarios

- Key Phrase Extraction
  - Identity the main concepts of a piece of text.
  - [Docs with example](https://learn.microsoft.com/en-us/azure/ai-services/language-service/key-phrase-extraction/overview)
- Entity Recongnition
  - This is when named items are located and categorized. Example: Detecting New York as a location.
  - Uses: PII Detection, Entity Linking
- Sentiment Analysis
  - Determines if the text conveys a certain emotion (Positive vs Negative) with a confidence score
- Language Modeling
  - This allows you to identity to learn the language of a certain text. This allows you to also summarize items.
- Speech Recongnition and Synthesis
- Language Translation

### Language Modeling Uses

- Language Detection
- Summarisation
- Pre-Built QA
  - Provides Quick Answers to a user
  - Is able to extract knowledge from your FAQ section OR Knowledge base
  - Can be integrated with chats like Teams
- Conversational Language
  - You can use this feature to pick up entities and intents from natual langauge (ex: _turn on_ the _bedroom light_)

## Azure Services

All Services with an \* are services which can be provisionsed to be dedicated OR used from a workspace that is shared with our AI services.

- Azure AI Language\*
  - Powers apps with NLP features.
  - From the above section, this service is able to perform all but the last 2 tasks.
- Azure AI Speech\*
  - TTS, S2T
  - Also Supports Translation
- Azure AI Translator\*
  - Real Time document trasnlator with cultural variances. 
  - You are able to develop your own custom Machine Translation Systems


# Misc Senarios

## Azure AI Doument Intelligence

> This is not to be confused with CV's OCR. Document Intelligence is a much more refined space for creating complex document based models.

This is used to automatically and *accurately*

- extract text
- create key-value pairs 
- Generate tables

from documents.

### Type of Models

- Document Analysis Models: They analyze the texts / forms and output in a structured format.
- Prebuilt Models: These are trained models which are ready for use allowing you to add intellegence to workflows without having to train your own models
- Custom Models: You are meant to use your own labaled datasets to train models.

There are many pre-existing models. Examples are:
1. Receipt Model
2. US Mortgage Model
3. ID/Passports Models
4. ...

## Azure AI Search

This helps you build sort of a search engine. It supports any structure of data even unstructured. It reads your data and creates json indexes. 

The components are:
- Indexers - Automates data indexing from azure resources. Example stores are Storage Accounts Blobs and SQL DBs. An Indexer turns this data into json. 
- Skillsets - Consumable AI from AI services sich as image or NLP. This is the *AI* part. A skillset is an Azure Skill like Entity Recongnition and applies it to the indexed items for AI Enrichment.

# GenAI

## GenAI Features

Generative AI Solutions are built on Large models like 
- Foundation Models - large models tuned to specfic tasks
- LLMs - Deep Learning Models for NLP

They Key features are creations of new media like new images, audio, video, or text. They are also customisable and interactive.

### Design Patterns

- Prompt Engineering
- Retrieval Argumented Generation
- Fine-Tuning
- Pre-Traning

### Common Uses

- Copilots - AI-driven tools to assist you in tasks. This is like a bot on Photoshop showing you how to use the tool which may be AI features like using Natual language to shade a part of the image.

## Services

- Azure OpenAI Service - Build your own copilot / OpenAI apps with this integration. Models supported: GPT, Embeddings, DALL-E, Whisper, Sora.
    - Access via OpenAI Studio, REST, or SDK
        - Open AI Studio:  
