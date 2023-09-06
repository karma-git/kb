import argparse
import logging
import json

import aiohttp
import asyncio

# py gh-issues.py aws/karpenter --count 15 | jq

async def gh_issue_worker(
    repo_path: str,
    state: str,
    count: int,
):
    async with aiohttp.ClientSession() as session:
        url = f"https://api.github.com/repos/{repo_path}/issues"
        headers = {}
        params = {
            "state": state,
            "page": 1,  # Начинаем с первой страницы
            "per_page": 100,  # Указываем количество результатов на странице (максимум 100)
        }

        all_issues = []

        while True:
            async with session.get(url, headers=headers, params=params) as response:
                if response.status == 200:
                    data = await response.json()
                    if not data:
                        break  # Выход из цикла, если больше нет данных

                    bucket = []
                    for issue in data:
                        row = {
                            "url": issue.get("html_url"),
                            "title": issue.get("title"),
                            "date": issue.get("created_at"),
                            "reactions_count": issue.get("reactions").get("total_count"),
                        }
                        bucket.append(row)
                    all_issues.extend(bucket)
                    params["page"] += 1  # Увеличиваем номер страницы для следующего запроса
                else:
                    logging.warning("something goes wrong", response)
                    return None

        # Сортируем по числу лайков
        all_issues = sorted(all_issues, key=lambda x: x["reactions_count"], reverse=True)
        return all_issues[:count]


def parse_args():
    parser = argparse.ArgumentParser(description="Fetch issues from a GitHub repository.")
    parser.add_argument("repo_path", help="GitHub repository namespace")
    parser.add_argument("-s", "--state", help="State of the issue", default="open", choices=["open", "closed"])
    parser.add_argument("-c", "--count", help="GitHub API token", default=5)
    return parser.parse_args()


async def main():
    args = parse_args()

    issues = await gh_issue_worker(args.repo_path, args.state, int(args.count))
    if issues:
        print(json.dumps(issues, indent=4))
    else:
        print("Failed to fetch issues.")


if __name__ == "__main__":
    asyncio.run(main())
