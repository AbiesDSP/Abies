import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setuptools.setup(
    name="abies", # Replace with your own username
    version="0.0.1",
    author="AbiesDSP",
    author_email="none@none.com",
    description="description",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/AbiesDSP/Abies",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: GPLv3",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
)
