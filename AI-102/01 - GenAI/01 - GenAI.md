# Develop generative AI apps in Azure

**AI Foundry** is a platform for AI development on Azure.

AI solutions are built on machine learning models which map and find relations between points of data.

Common AI Capability are:

-   _Generate AI_
    -   Agents
-   Computer Vision
-   Speech
-   NLP
-   Information Extraction
-   Decision Support

GenAI, uses large language models to respond to natual language prompts enabling conversational applications. Sometimes small-language models are employed.

There are many AI services on Azure, they will **NOT** be listed here.

## AI Foundry Platform

AI Foundry Platform is used for project organization. It is very possible to use the underlying AI services without AI foundry, it is reccomended as it makes it easier to manage resources. It is possible to use the foundry with portal or SDK access. One way this platform makes things easy is it creates a single location where you can see all of your service endpoints along with keys to access them.

A foundry project is associated with an Azure AI Foundry resource, this can allow you to centralize things like models, datasets, and understand deployments.

A hub-based project is associated with an Azure AI hub, now this also has an Azure AI Foundry resource attached to it. But, it has additional features like

-   managed compute
-   managed storage
-   managed keys for security

Evidently, the Hub is for advanced projects.

## DevX

-   Any IDE works
-   Multi-Language support

Some important mentions:

-   Azure AI Foundry SDK - enables you a single location to connect to your services.
-   Each AI service has its own SDK as well

## Models

First you have to choose a model which best fits you needs, the model catalog can show you what a model is good at.

Some basic types of models:

1. chat completion - used to generate coherent text-based responses
2. multi-modal - can process different types of data
3. image generation
4. embedding models - convert text into numerical representations (more on this later)

Often times some models are better in certain languages than others. For example, Mistral Large is tried on certain european langauges.

### Model Selection Process

Here are the Azure related items to think on:
-   Task type
-   Precision - Do you need fine tuning?
    -   Openness - can your model be tuned?
-   Deployment - do you need a managed deployment or a locally hosted one

For the model it self, think of the following:

- Precision measures "accuracy of the model in generating correct and relevant outputs".

$$
P = \frac{\text{True Positive}}{\text{TP + FP}}
$$

- Benchmarks
   - Accuracy
   - Coherence
   - Fluency (does it adhere to grammer rules?)
   - Groundness (hallucinations?)
   - Costs per token
   - GPT Similarity

### Model Deployment On Azure

Deployment Options:

- Standard
- Serverless Compute
- Managed Compute

Each have different hosting methods and each support differet models. 

