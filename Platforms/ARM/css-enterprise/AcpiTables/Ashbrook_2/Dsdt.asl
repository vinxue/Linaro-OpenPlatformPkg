/** @file
  Differentiated System Description Table Fields (DSDT)

  Copyright (c) 2014-2016, ARM Ltd. All rights reserved.<BR>
    This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/

#include "ArmPlatform.h"

DefinitionBlock("DsdtTable.aml", "DSDT", 1, "ARMLTD", "ARM-ASHBROOK", EFI_ACPI_ARM_OEM_REVISION) {
  Scope(_SB) {
    //
    // A72x4 Processor declaration
    //
    Device(CP00) { // A72-0: Cluster 0, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 0)
    }
    Device(CP01) { // A72-0: Cluster 0, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 1)
    }
    Device(CP02) { // A72-0: Cluster 0, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 2)
    }
    Device(CP03) { // A72-0: Cluster 0, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 3)
    }

    Device(CP04) { // A72-0: Cluster 1, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 4)
    }
    Device(CP05) { // A72-0: Cluster 1, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 5)
    }
    Device(CP06) { // A72-0: Cluster 1, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 6)
    }
    Device(CP07) { // A72-0: Cluster 1, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 7)
    }

    Device(CP08) { // A72-0: Cluster 2, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 8)
    }
    Device(CP09) { // A72-0: Cluster 2, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 9)
    }
    Device(CP10) { // A72-0: Cluster 2, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 10)
    }
    Device(CP11) { // A72-0: Cluster 2, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 11)
    }

    Device(CP12) { // A72-0: Cluster 3, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 12)
    }
    Device(CP13) { // A72-0: Cluster 3, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 13)
    }
    Device(CP14) { // A72-0: Cluster 3, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 14)
    }
    Device(CP15) { // A72-0: Cluster 3, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 15)
    }

    Device(CP16) { // A72-0: Cluster 4, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 16)
    }
    Device(CP17) { // A72-0: Cluster 4, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 17)
    }
    Device(CP18) { // A72-0: Cluster 4, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 18)
    }
    Device(CP19) { // A72-0: Cluster 4, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 19)
    }

    Device(CP20) { // A72-0: Cluster 5, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 20)
    }
    Device(CP21) { // A72-0: Cluster 5, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 21)
    }
    Device(CP22) { // A72-0: Cluster 5, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 22)
    }
    Device(CP23) { // A72-0: Cluster 5, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 23)
    }

    Device(CP24) { // A72-0: Cluster 6, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 24)
    }
    Device(CP25) { // A72-0: Cluster 6, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 25)
    }
    Device(CP26) { // A72-0: Cluster 6, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 26)
    }
    Device(CP27) { // A72-0: Cluster 6, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 27)
    }

    Device(CP28) { // A72-0: Cluster 7, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 28)
    }
    Device(CP29) { // A72-0: Cluster 7, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 29)
    }
    Device(CP30) { // A72-0: Cluster 7, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 30)
    }
    Device(CP31) { // A72-0: Cluster 7, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 31)
    }

    Device(CP32) { // A72-0: Cluster 8, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 32)
    }
    Device(CP33) { // A72-0: Cluster 8, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 33)
    }
    Device(CP34) { // A72-0: Cluster 8, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 34)
    }
    Device(CP35) { // A72-0: Cluster 8, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 35)
    }
    
    Device(CP36) { // A72-0: Cluster 9, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 36)
    }
    Device(CP37) { // A72-0: Cluster 9, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 37)
    }
    Device(CP38) { // A72-0: Cluster 9, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 38)
    }
    Device(CP39) { // A72-0: Cluster 9, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 39)
    }

    Device(CP40) { // A72-0: Cluster 10, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 40)
    }
    Device(CP41) { // A72-0: Cluster 10, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 41)
    }
    Device(CP42) { // A72-0: Cluster 10, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 42)
    }
    Device(CP43) { // A72-0: Cluster 10, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 43)
    }

    Device(CP44) { // A72-0: Cluster 11, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 44)
    }
    Device(CP45) { // A72-0: Cluster 11, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 45)
    }
    Device(CP46) { // A72-0: Cluster 11, Cpu 2
      Name(_HID, "ACPI0007")
      Name(_UID, 46)
    }
    Device(CP47) { // A72-0: Cluster 11, Cpu 3
      Name(_HID, "ACPI0007")
      Name(_UID, 47)
    }

    // UART PL011
    Device(COM0) {
      Name(_HID, "ARMH0011")
      Name(_CID, "PL011")
      Name(_UID, Zero)
      Name(_CRS, ResourceTemplate() {
        Memory32Fixed(ReadWrite, 0x7FF80000, 0x1000)
        Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) { 147 }
      })
    }

    // VIRTIO
    Device (VIRT) {
      Name (_HID, "LNRO0005")
      Name (_UID, 0)

      Name (_CRS, ResourceTemplate() {
        Memory32Fixed (ReadWrite, 0x1c130000, 0x10000)
        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive) { 202 }
      })
    }

    // SMSC 91C111
    Device(ETH0) {
      Name(_HID, "LNRO0003")
      Name(_UID, Zero)
      Name(_CRS, ResourceTemplate() {
            Memory32Fixed(ReadWrite, 0x18000000, 0x1000)
            Interrupt(ResourceConsumer, Level, ActiveHigh, Exclusive) { 111 }
      })
      Name(_DSD, Package() {
                 ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                     Package() {
                     Package(2) {"reg-io-width", 4 },
                    }
      }) // _DSD()
    }
  } // Scope(_SB)
}
