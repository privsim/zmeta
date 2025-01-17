import requests

def fetch_trending_huggingface_models():
    """Fetch and display trending models from Hugging Face."""
    hf_api_url = "https://huggingface.co/api/models?sort=likes7d&direction=-1"
    try:
        response = requests.get(hf_api_url)
        response.raise_for_status()
        models = response.json()
        print("Trending Hugging Face Models:")
        for i, model in enumerate(models[:10], 1):  # Fetch top 10 models
            print(f"{i}. {model['modelId']} - {model.get('likes', 0)} likes")
            print(f"   Link: https://huggingface.co/{model['modelId']}")
    except requests.RequestException as e:
        print(f"Error fetching Hugging Face trending models: {e}")

def fetch_trending_github_repositories():
    """Fetch and display trending repositories from GitHub."""
    gh_trending_url = "https://api.github.com/search/repositories?q=stars:>1&sort=stars&order=desc"
    try:
        response = requests.get(gh_trending_url, headers={"Accept": "application/vnd.github.v3+json"})
        response.raise_for_status()
        repositories = response.json().get("items", [])
        print("\nTrending GitHub Repositories:")
        for i, repo in enumerate(repositories[:10], 1):  # Fetch top 10 repositories
            print(f"{i}. {repo['full_name']} - {repo['stargazers_count']} stars")
            print(f"   Link: {repo['html_url']}")
    except requests.RequestException as e:
        print(f"Error fetching GitHub trending repositories: {e}")

if __name__ == "__main__":
    print("Fetching trending data...\n")
    fetch_trending_huggingface_models()
    fetch_trending_github_repositories()
