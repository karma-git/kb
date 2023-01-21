#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Simple Caesar cipher.
Read more -> https://en.wikipedia.org/wiki/Caesar_cipher
"""
from string import ascii_lowercase
from dataclasses import dataclass


@dataclass
class ShiftDirection:
    """Side value should be <left> or <right>"""

    side: str


class CaesarCipher:
    """
    Params:
    text -> plain text to encode it, or encoded text to decode it (direction should be reversed)
    shift -> char rotation
    direction -> ShiftDirection instance, should be <left> or <right>
    """
    def __init__(self, text: str, shift: int, direction: ShiftDirection):
        self.text = text
        self.shift = shift
        self.direction = direction

    def _ciper_calculator(self, char: str) -> str:
        """
        Calculate new char
        """
        # Helpers
        ALPHABET_CAPACITY = len(ascii_lowercase)
        sign = lambda x: -1 if x < 0 else 1

        char_case = "lower" if char.islower() else "upper"
        char_index = ascii_lowercase.find(char.lower())

        # Validate input char
        if not len(char) == 1:
            raise ValueError(f"Only 1 symbol allowed, -> {char}")
        if not 0 <= char_index <= ALPHABET_CAPACITY:
            raise ValueError(f"{char_index} is not in alhabet index range")

        # Make sure that shift is not higher then alhabet capacity
        if abs(self.shift) > ALPHABET_CAPACITY:
            shift_sign = sign(self.shift)
            i = abs(self.shift)
            while i <= ALPHABET_CAPACITY:
                i -= ALPHABET_CAPACITY

            self.shift = i * shift_sign

        # Calculate new char
        if self.direction.side == "left":
            char_new_index = char_index - self.shift
        elif self.direction.side == "right":
            char_new_index = char_index + self.shift
        else:
            raise TypeError(f"Method {self.direction.side} is not allowed")

        char_index_sign = sign(char_new_index)
        char_abs = abs(char_new_index)
        while char_abs >= ALPHABET_CAPACITY:
            char_abs -= ALPHABET_CAPACITY
        char_new_index = char_abs * char_index_sign

        # Render char and it's case
        char = ascii_lowercase[char_new_index]
        char = char.upper() if char_case == "upper" else char

        return char

    def process(self) -> str:
        """
        Main payload
        """
        result_text = ""
        for char in self.text:
            if char.isalpha():
                result_char = self._ciper_calculator(char)
                result_text += result_char
            else:
                result_text += char

        return result_text
