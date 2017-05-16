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

DefinitionBlock("DsdtTable.aml", "DSDT", 1, "ARMLTD", "ARM-ASHBROOK_5", EFI_ACPI_ARM_OEM_REVISION) {
  Scope(_SB) {
    //
    // A53x4 Processor declaration
    //
    Device(CP00) { // A53-0: Cluster 0, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 0)
    }
    Device(CP01) { // A53-0: Cluster 0, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 1)
    }

    Device(CP04) { // A53-0: Cluster 1, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 2)
    }
    Device(CP05) { // A53-0: Cluster 1, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 3)
    }

    Device(CP08) { // A53-0: Cluster 2, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 4)
    }
    Device(CP09) { // A53-0: Cluster 2, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 5)
    }

    Device(CP12) { // A53-0: Cluster 3, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 6)
    }
    Device(CP13) { // A53-0: Cluster 3, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 7)
    }

    Device(CP16) { // A53-0: Cluster 4, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 8)
    }
    Device(CP17) { // A53-0: Cluster 4, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 9)
    }

    Device(CP20) { // A53-0: Cluster 5, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 10)
    }
    Device(CP21) { // A53-0: Cluster 5, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 11)
    }

    Device(CP24) { // A53-0: Cluster 6, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 12)
    }
    Device(CP25) { // A53-0: Cluster 6, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 13)
    }

    Device(CP28) { // A53-0: Cluster 7, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 14)
    }
    Device(CP29) { // A53-0: Cluster 7, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 15)
    }

    Device(CP32) { // A53-0: Cluster 8, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 16)
    }
    Device(CP33) { // A53-0: Cluster 8, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 17)
    }
   
    Device(CP36) { // A53-0: Cluster 9, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 18)
    }
    Device(CP37) { // A53-0: Cluster 9, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 19)
    }

    Device(CP40) { // A53-0: Cluster 10, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 20)
    }
    Device(CP41) { // A53-0: Cluster 10, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 21)
    }

    Device(CP44) { // A53-0: Cluster 11, Cpu 0
      Name(_HID, "ACPI0007")
      Name(_UID, 22)
    }
    Device(CP45) { // A53-0: Cluster 11, Cpu 1
      Name(_HID, "ACPI0007")
      Name(_UID, 23)
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
