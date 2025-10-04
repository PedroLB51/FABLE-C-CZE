<span style="font-size: 10px;">

# FABLE-C-CZE Version Control Guidelines
## 1. Project Overview
This document outlines the version control workflow for the FABLE Calculator for Czechia. 
We use **Git/Github** for code and documentation versioning and **DVC (Data Versioning Control)** for managing Excel data files and large datasets.
## 2. Repository Structure
The Repository hosts the national calibration data, scripts, and metadata.

    FABLE-C-CZE/
    ├── raw/                  # Original, immutable data from sources
    │   ├── cso/              # Czech Statistical Office (ČSÚ)
    │   ├── chmi/             # Czech Hydrometeorological Institute
    │   ├── mze/              # Ministry of Agriculture
    │   ├── mzp/              # Ministry of Environment
    │   │
    ├── processed/            # Cleaned, transformed data in FABLE format
    │   ├── agriculture/      # Crop and Livestock
    │   ├── biodiversity/     # Biodiversity indicators
    │   ├── land_use/         # Land use and land use change
    │   └── emissions/        # GHG and air pollution
    ├── scripts/              # Data proccesing or analysis script
    │   ├── r/                # R scripts for analysis
    │   └── gams/             # GAMS model scripts
    ├── upstream/             # Official FABLE files from the Secretariat (baselines, updates)
    ├── outputs/              # Model results and reports
    ├── metadata/             # Documentation, dara dictionaries and metadata files

## 3. Workflow for handling files
Files are stored **in local** folder base on category. 
Raw data **is immutable**, processed data will be updated as part of calibration.
Every update, changes or new version of a file should be also updated on the GitHub with a commit comment.
Files should not be modify directly on the GitHub website.
### Update files
git pull
dvc pull
dvc add *folder location*/*file name.xlsx* # Example: processed/agriculture/crop_production_cso_2000-2025.xlsx
git add .
git commit -m "[*folder location*]: *Descriptive message about changes*" # Example: [processed/agriculture]: updated crop production including 2025"
dvc push
git push
### Add new data
dvc add raw/cso/new_data.csv    # Example using cso folder
git add raw/cso/new_data.csv.dvc .gitignore
git add commit -m "[*folder location*]: *Description of new data*" # Example: "[raw/cso]: Added livestock trade balance 2025"
dvc push
git push
### Download and check Datasets
git pull
dvc pull
## 4. File Naming and Management Workflow
Raw data should keep original names from sources. # Example: ZEM06A.xlsx (file containing number of livestock heads by year)
Processed data files use lowercase, underscores (_), and include source + year/period if relevant. # Example: lulucf_emissions_chmi_2020-2025.xlsx
Avoid accents (č, ř, š), or special characters.
Dates should preferable use YYYY format.

Data management create and maintain folder structure, transform raw data to processed data.
Updates will be made when:
    - New file is added
    - Existing file is modified
    - Folder created or reorganized
    - Errors fixed
    - New documentation is added
## 5. Rules
    - Main branch = stable data. Only validated updates are push.
    - Main work is done locally.
    - Every change must be accompanied with clear commit messages.
## 6. Metadata and Documentation
Every dataset in /raw or /processed must have a metadata entry in /metadata.
Metadata file should include:
    - Source (institution, link)
    - Time coverage
    - Units and variables
    - Transformations (if processed)
    - Contact person (if internal)
    - Last update
## 7. Good Practices
    - Pull (git pull + dvc pull) before working.
    - Commit often but meaningfully: 
        a. Files in the source folder
        b. Processed files with descriptive names, use [] to describe the source folder where the action took place
        c. Metadata updated
    - Push at the end of each work session.
## 8. About This Repository
    - Maintained by: Pedro Lezama - CzechGlobe Institute 
    - Based on the FABLE Calculator
    - IDE: Visual Studio Code
    - For internal use: not all data may be public


