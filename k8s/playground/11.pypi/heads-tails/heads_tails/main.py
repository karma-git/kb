from random import random
import click

@click.command()
def head_tails():
    if random() * 100 < 50:
        click.echo('Head!')
    else:
        click.echo('Tails!')
