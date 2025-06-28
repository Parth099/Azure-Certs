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

> Fine Tuning is not RAG

This changes the behavior outside of the System prompt.

See that model weights have been determined by the provider of the subject model. Here is the fine tuning process 

## Trends AI

-   Multi Modal Solutions
    -   Set the correct model for the task and price
-   Agents
-   SLM (mil, bil) vs LLM (Trillions of Params)

[^1]: You are able to create copilots from natural language prompts to a builder.
