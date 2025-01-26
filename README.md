# Code Review AI

Code Review AI is a CLI tool that leverages OpenAI to generate code reviews and branch summaries effortlessly. It analyzes the differences between the current branch and the main (or master) branch and provides actionable code improvement suggestions.

## Features

- **AI-Powered Code Review**: Automatically generate code review comments based on repository changes.
- **Branch Summary**: Generate a concise summary of the changes made in a branch.

## Installation

To install the gem, run:

```sh
gem install code-review-ai
```
After installing the gem, please run the following command to install Node.js dependencies:
```sh
npm install -g standard-version
```

## Usage

### Commands

- **review**: Conduct AI code review on the current branch.
- **summary**: Generate a branch change summary.

### Environment Variables

- **OPENAI_ACCESS_TOKEN**: OpenAI API key.
- **OPENAI_MODEL**: AI model (default: gpt-3.5-turbo).
- **OPENAI_LANGUAGE**: Output language (default: English).

### Example

```sh
code-review-ai --command review --api-key YOUR_API_KEY --model gpt-3.5-turbo --language English
```

### Options

- `-k`, `--api-key KEY`: OpenAI API key.
- `-m`, `--model MODEL`: AI model to use.
- `-l`, `--language LANG`: Language for output.
- `-c`, `--command CMD`: Command (review or summary).

## Development

### Running Tests

To run the tests, use the following command:

```sh
rspec
```

### Linting

To check for style issues, use RuboCop:

```sh
rubocop
```

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
