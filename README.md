# Allora Worker

<div style="text-align: center;">
<img src="https://cdn.prod.website-files.com/667c44f051907593fdb7e7fe/667c789fa233d4f02c1d8cfa_allora-webclip.png" alt="Allora Logo" width="200"/>
</div>

Allora Worker serves as the foundation for running machine learning models as part of the Allora network. The worker is built using FastAPI for serving model inferences via RESTful APIs. It dynamically loads and runs models from the package folder, making it highly flexible and scalable for adding or switching models.

# Table of Contents

1. [Initial Setup: Importing Packaged Models](#initial-setup-importing-packaged-models)
   - [1.1 Package the Model in allora-model-maker](#package-the-model-in-allora-model-maker)
   - [1.2 Copy Files to allora-worker](#copy-files-to-allora-worker)
   - [1.3 Paste into allora-worker](#paste-into-allora-worker)

2. [Installation](#installation)
   - [2.1 Clone the Repository](#clone-the-repository)
   - [2.2 Create and Activate Virtual Environment](#create-and-activate-virtual-environment)
   - [2.3 Install Required Dependencies](#install-required-dependencies)

3. [Folder Structure](#folder-structure)

4. [Model Packaging Workflow](#model-packaging-workflow)
   - [4.1 Packaging a Model](#packaging-a-model)
   - [4.2 Copying Packaged Model to allora-worker](#copying-packaged-model-to-allora-worker)

5. [Model Configuration](#model-configuration)

6. [Usage](#usage)
   - [6.1 Running FastAPI Server](#running-fastapi-server)

7. [API Endpoints](#api-endpoints)
   - [7.1 POST: /inference/](#post-inference)
   - [7.2 GET: /inference/](#get-inference)
   - [7.3 GET: /update-model/](#get-update-model)

8. [Contributing](#contributing)

9. [General Best Practices](#general-best-practices)

10. [License](#license)


### Initial Setup: Importing Packaged Models

To deploy a packaged model in the allora-worker environment, follow these steps:

##### Package the Model in allora-model-maker

First, go to your [allora-model-maker](https://github.com/allora-network/allora-model-maker) repository and package your trained model using the following command:

```
make package-arima
```

This will generate a folder called package in the packaged_models directory of the allora-model-maker repo.

##### Copy Files to allora-worker

Next, navigate to the packaged_models folder in allora-model-maker.

	Copy the entire package folder, you will place this into the allora-woker repo in the next step.

##### Paste into allora-worker

	Go to the root folder of your allora-worker repository and paste the copied package folder file into the root directory.

Your allora-worker environment is now set up to use the packaged model for inference and training.

#### Installation ####

Follow these steps to set up the repository:

#####	Clone the repository:
```
git clone https://github.com/allora-network/allora-worker.git
cd allora-worker
```
#####	Create and Activate Virtual Environment:
```
conda create -n modelworker python=3.9
conda activate modelworker
```
#####	Install Required Dependencies:
```
pip install -r src/requirements.txt
```

#### Folder Structure ####

The repository is structured as follows:

```
allora-worker/
├── src/
│   ├── endpoints/                    # Contains API endpoints for various functionality
│   │   ├── model_inference.py         # Handles GET/POST for model inference
│   │   └── data_preprocessing.py      # Handles GET/POST for data preprocessing
│   ├── package/                      # Contains all models and trained models
│   │   ├── lstm/
│   │   │   ├── model.py                # LSTM model code
│   │   │   └── trained/
│   │   │       └── model.pt            # Trained LSTM model
│   │   └── arima/
│   │       ├── model.py                # ARIMA model code
│   │       └── trained/
│   │           └── model.pkl           # Trained ARIMA model
│   ├── utils/                        # Utility functions used across the worker
│   │   ├── utils_shared.py             # Shared/common utilities (logging, config, etc.)
│   │   ├── model_utils.py              # Model-specific utilities (loading, saving)
│   ├── main.py                       # FastAPI entry point for inference
│   ├── requirements.txt              # Production dependencies (FastAPI, Uvicorn)
│   ├── requirements-dev.txt          # Development dependencies (testing, linters)
└── README.md                         # Instructions for deployment and usage
```
- Endpoints have been modularized under the `src/endpoints/` folder.
- Model weights are stored in the `src/package/trained_models/` folder for easier organization of model versions.

#### Model Packaging Workflow allora-model-maker ####

The models to be used in the Allora worker need to be packaged from the [allora-model-maker](https://github.com/allora-network/allora-model-maker) repository.
Here’s the basic workflow:

#####	Packaging a Model

```
make package model_name=your_model_name
```
This will generate the following:
	•	The packaged model in packaged_models/ folder

#####	Copying Packaged Model to allora-worker
Copy the **package** folder into the root of the **allora-worker/src** repository.


#### Model Configuration ####

You must pass an environmetn variable MODEL to set the default, we also provided a model topic config that you can set in order to set which model would run based on which topid was used.

```
MODEL=lstm make run # Set to the active model
```


#### Usage ####

Once the repository is set up with the necessary models, you can run the Allora worker to start serving the APIs.

#####	Running FastAPI server:
```
MODEL=arima uvicorn main:app --reload --port 8000

OR

MODEL=arima make run
```
You should see output indicating that the server is running:
```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
```

#### API Endpoints ####

The Allora worker exposes the following endpoints:

1.	#### POST: /inference/
	•	Description: Perform inference on the model using a JSON payload.
	•	Input: JSON data containing model features.
	•	Example Usage:
```
curl -X POST "http://127.0.0.1:8000/inference" -H "Content-Type: application/json" -d ‘{"open": […], "close": […], "volume": […], "high": […], "low": […] }’
```
2.	#### GET: /inference/
	•	Description: Perform inference using a URL-encoded payload.
	•	Input: URL-encoded JSON data containing model features.
	•	Example Usage:
```
curl "http://127.0.0.1:8000/inference"
```

3.	#### GET: /update-model/

The worker includes an optional automated training endpoint available at:

   •	Description: Trigger model training or retraining. Can be set up for periodic tasks or manually called.
   •	Example Usage:
```
curl "http://127.0.0.1:8000/update-model"
```

## Contributing

Contributions are welcome! To ensure a smooth contribution process, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch:**
    ```git checkout -b feature-branch ```
3. **Make your changes.**
4. **Before committing your changes, run the following Makefile commands to ensure code quality and consistency:**

   - **Lint your code:**
      ```make lint ```

   - **Format your code:**
      ```make format ```

   - **Run tests to ensure everything works:**
      ```make test ```

5. **Commit your changes:**
    ```git commit -am 'Add new feature' ```

6. **Push to your branch:**
    ```git push origin feature-branch ```

7. **Create a pull request.**

### General Best Practices

- Ensure your code follows the project's coding standards by using `pylint` for linting and `black` for formatting.
- Test your changes thoroughly before pushing by running the unit tests.
- Use meaningful commit messages that clearly describe your changes.
- Make sure your branch is up-to-date with the latest changes from the main branch.
- Avoid including unnecessary files in your pull request, such as compiled or cache files. The `make clean` command can help with that:

   ```make clean ```

By following these practices, you help maintain the quality and consistency of the project.

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
