"""
Test
"""
import pytest
from caesar_cipher import (
    ShiftDirection,
    CaesarCipher,
)

case1 = ("Hello World!", "Khoor Zruog!", 3, "right")

case2 = ("I came, I saw, I conquered", "W qoas, W gok, W qcbeisfsr", 40, "right")

case3 = (
    "A day may come when I stop writing at python, but it is not this day.",
    "Y byw kyw amkc ufcl G qrmn upgrgle yr nwrfml, zsr gr gq lmr rfgq byw.",
    180,
    "right",
)

case4 = ("Lucky 13", "Ktbjx 13", 1, "left")

case5 = ("Bob Woods", "Cpc Xppet", 25, "left")

test_cases = [
    case1,
    case2,
    case3,
    case4,
    case5,
]


@pytest.mark.parametrize("plain, cipher, shift, direction", test_cases)
def test_caesar_cipher(plain: str, cipher: str, shift: int, direction: str):
    """
    main payload
    """
    enode_direction = ShiftDirection(side=direction)
    reverse = "right" if direction == "left" else "left"
    decode_direction = ShiftDirection(side=reverse)

    # ENCODE
    caesar_cipher = CaesarCipher(plain, shift, enode_direction)
    encode_text = caesar_cipher.process()
    assert encode_text == cipher

    # DECODE
    caesar_cipher = CaesarCipher(cipher, shift, decode_direction)
    decode_text = caesar_cipher.process()
    assert decode_text == plain
