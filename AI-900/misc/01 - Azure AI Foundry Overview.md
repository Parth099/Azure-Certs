# Azure AI Foundry

> Azure AI Foundry provides a unified platform for enterprise AI operations, model builders, and application development.

## Capabilities

### Background

#### MSFT **C**opilot

These are AI Assistant Products.

-   Github Copilot
-   Azure Copilot
-   M365 Copilot

These are often for productivity.

#### Your *c*opilot

This is when a MSFT product above doesnt meet your requirement. These are made with the low code[^1] `Copilot Studio`; this can help you make new custom copilots OR extend extend CPs.

One special feauture to highlight here is that you may use something call `grounding` in which additional information is sent on a model inference request to help it give you a better response. This can be items such as

-   time and date information
-   company internal documents
-   ...

### Azure AI Foundry

Azure AI Foundry is a high-code solution to help build AI-powered solutions.

The main things to focus on are:

1. Models
    - 1800+ Models in the MSFT Collection
	- You can also access the trad models here like `Azure Speech`
	- Models are ready only. The Model does not learn from your queries. 
	- These models are running in Azure
	- Models come with Benchmarks to help you understand what are the IO & what the model is good at
	    - Quality Index
		- Knowledge Cutoff Date
		- Cost
		- Comparison with other models
	- You may experiment with Models in the `Chat Playground`
2. Tooling
    - The Azure Portal can perform the required task but so can the SDK.
3. Safety
    - Some models are curated my MSFT and MSFT may offer SLA on these models in terms of items like Latency


- Deployment Models - Regardless of choice they model runs *on azure*. Model providers can only see billing data
    - Serverless - via end endpoint, user does not have to do much work. You will pay per use
	   - The backend is pools of deployed Models per region.
	- Managed Compute - This is a IaaS via VM. Notice the provider here is taken out of the billing equation here. You will pay regardless of use as you have *reserved* some infrastructure for the model

#### Evalation & Tracing

Benchmarks may not fir the bill when you are looking for what model is the best for your prompts. In this case, you need to use a Judge Model to check the outputs of a series of models. 

Tracing is how you may debug your AI-based app. It is a dashboard built on top of LAWs. 

#### Fine Tuning

> Fine Tuning is not RAG. This is typically used for Smaller Models

This changes the behavior outside of the System prompt.

See that model weights have been determined by the provider of the subject model. Here is the fine tuning process 

1. Model Exists with default weights (original traning)
2. Generate File $F$ with input & output
3. Send $F$ to the fine tuning exercise 
4. Model is updated

This can be used to changed to model for speaking more legally or better for medical talks.

#### Distillation

In this scheme you are often giving a LLM a set of data and them this data is used to generate some traning data $T$. Then $T$ is used as $F$ in the fine tuning process. 

#### Inferencing API

Suppose your APP is using AI Models inside via an API. You may use the Inferencing API which is a layer above the actual API for the model you are trying to use. The goal of the Inferencing API is to allow you to write a set of API calls which can target any model as Azure in the background will transform your calls depending on the model you need.  

## Safety 

> You are unsure what an LLM may output

### Content Filters

Lets call the input $I$ and the output $O$. 

Categories can be applied to $I$ and $O$ in terms of text and images to ensure certain items are not put into the model OR output from the model. 

Azure also allows you to 
- block jailbreak attacks
- block indirect attacks

These are known are prompt shields. 

These filters can be applied to $I/O$ allow your better catching of items. 

Custom Categories are also applicable
- allows you to block certain topics
- allows you ensure model stays grounded



## Trends AI

-   Multi Modal Solutions
    -   Set the correct model for the task and price
-   Agents
-   SLM (mil, bil) vs LLM (Trillions of Params)

## Agents

There is an Agent Service, it can run tasks on your behalf. You are able to give it these items

1. Tasks 
2. Actions (ex: Azure Function endpoints)
3. Information (ex: Azure AI search)

Often times agents can work together to perform self validation

## Using AI Foundary

### Hubs

Centralized *Repo* for your AI service
- Data
- endpoints
- connections
- security settings ...

### Projects

A child of a Hub. 

This data is isolated as its solely for the project. The Hub keeps all the shared items. 





[^1]: You are able to create copilots from natural language prompts to a builder.
