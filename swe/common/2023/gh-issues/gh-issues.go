package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
	"sort"
	"strconv"

	"github.com/go-resty/resty/v2"
	"github.com/urfave/cli/v2"
)

// go run gh-issues.go aws/karpenter --count 15 | jq

type Issue struct {
	URL       string `json:"html_url"`
	Title     string `json:"title"`
	Date      string `json:"created_at"`
	Reactions struct {
		TotalCount int `json:"total_count"`
	} `json:"reactions"`
}

func fetchGitHubIssues(repoPath string, state string, count int) ([]Issue, error) {
	client := resty.New()

	url := fmt.Sprintf("https://api.github.com/repos/%s/issues", repoPath)
	params := map[string]string{
		"state":    state,
		"page":     "1",
		"per_page": "100",
	}

	var allIssues []Issue

	for {
		response, err := client.R().
			SetQueryParams(params).
			Get(url)

		if err != nil {
			return nil, err
		}

		if response.StatusCode() != 200 {
			return nil, fmt.Errorf("GitHub API request failed with status code: %d", response.StatusCode())
		}

		var issues []Issue
		err = json.Unmarshal(response.Body(), &issues)
		if err != nil {
			return nil, err
		}

		if len(issues) == 0 {
			break
		}

		allIssues = append(allIssues, issues...)
		page, _ := strconv.Atoi(params["page"])
		params["page"] = strconv.Itoa(page + 1)
	}

	sort.Slice(allIssues, func(i, j int) bool {
		return allIssues[i].Reactions.TotalCount > allIssues[j].Reactions.TotalCount
	})

	if len(allIssues) > count {
		allIssues = allIssues[:count]
	}

	return allIssues, nil
}


func main() {
	app := &cli.App{
		Name:  "gh-issues",
		Usage: "Fetch issues from a GitHub repository.",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:    "state",
				Aliases: []string{"s"},
				Value:   "open",
				Usage:   "State of the issue (open/closed)",
			},
			&cli.IntFlag{
				Name:    "count",
				Aliases: []string{"c"},
				Value:   5,
				Usage:   "Number of issues to fetch",
			},
		},
		Action: func(c *cli.Context) error {
			repoPath := c.Args().Get(0)
			state := c.String("state")
			count := c.Int("count")

			issues, err := fetchGitHubIssues(repoPath, state, count)
			if err != nil {
				log.Fatal(err)
			}

			jsonData, err := json.MarshalIndent(issues, "", "    ")
			if err != nil {
				log.Fatal(err)
			}

			fmt.Println(string(jsonData))

			return nil
		},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
