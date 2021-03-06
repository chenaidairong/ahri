package main

import (
	"crypto/aes"
	"fmt"
	"github.com/KevinZonda/ahri/core"
)

func main() {
	text := "I am Groot. I am Groot. I am Groot. I am Groot. I am Groot. "
	key := [32]byte{
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x03, 0x00, 0x02, 0x01, 0x00, 0x00,
		0xff, 0x00, 0x04, 0x04, 0x00, 0xaa, 0x00, 0x00,
		0x00, 0x00, 0x06, 0x00, 0x00, 0xfa, 0x00, 0x00,}
	aesCipher, _ := aes.NewCipher(key[:])
	originData := []byte(text)
	decrypted := core.DecryptAesCfb256(core.EncryptAesCfb256(originData, aesCipher), aesCipher)
	fmt.Println(string(decrypted) == text)
}
