#!/bin/bash
make
dd if=dehaxos.img of=dehaxos.img bs=1474560 count=1 conv=notrunc,sync