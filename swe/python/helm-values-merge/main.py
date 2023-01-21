# pip install deepmerge pyaml
from copy import deepcopy

import yaml
from deepmerge import Merger

m = Merger(
    # ref: https://deepmerge.readthedocs.io/en/latest/strategies.html#builtin-strategies
    [
        (list, ["override"]),
        (dict, ["merge"]),
        (set, ["union"])
    ],
    # fallback
    ["use_existing"],
    # conflict
    ["use_existing"]
)

def main() -> None:
    with open("chart.values.yaml") as y:
        chart = yaml.safe_load(y)
    with open("release.values.yaml") as y:
        release = yaml.safe_load(y)

    # save copy of release values
    release_values = deepcopy(release)

    # all that we want is set, except we got chart Lists instead of Release Lists
    m.merge(release, chart)
    # return release lists
    m.merge(release, release_values)

    with open("merged.values.yaml", "w") as y:
        yaml.dump(release, y)

if __name__ == "__main__":
    main()
