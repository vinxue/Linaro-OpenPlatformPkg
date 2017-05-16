/** @file
*
*  Copyright (c) 2013-2014, ARM Limited. All rights reserved.
*
*  This program and the accompanying materials
*  are licensed and made available under the terms and conditions of the BSD License
*  which accompanies this distribution.  The full text of the license may be found at
*  http://opensource.org/licenses/bsd-license.php
*
*  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
*  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
*
**/

#ifndef __ARM_ASHBROOK_H__
#define __ARM_ASHBROOK_H__

#include <VExpressMotherBoard.h>

/***********************************************************************************
// Platform Memory Map
************************************************************************************/

// NOR Flash 0
#define ARM_VE_SMB_NOR0_BASE                  0x08000000
#define ARM_VE_SMB_NOR0_SZ                    SIZE_128MB

// Motherboard Peripheral and On-chip peripheral
#define ARM_VE_BOARD_PERIPH_BASE              0x1C010000
#define ARM_VE_BOARD_PERIPH_BASE_SZ           SIZE_2MB

// SP810 Controller
#undef SP810_CTRL_BASE
#define SP810_CTRL_BASE                       0x1C020000

// Off-Chip peripherals (Ethernet, VRAM)
#define ARM_VE_SMB_PERIPH_BASE                0x18000000
#define ARM_VE_SMB_PERIPH_SZ                  SIZE_64MB

// On-Chip non-secure ROM
#define ASHBROOK_NON_SECURE_ROM_BASE          0x1F000000
#define ASHBROOK_NON_SECURE_ROM_SZ            SIZE_512KB

// On-Chip Peripherals
#define ASHBROOK_PERIPHERALS_BASE             0x20000000
#define ASHBROOK_PERIPHERALS_SZ               0x0E000000

// On-Chip non-secure SRAM
#define ASHBROOK_NON_SECURE_SRAM_BASE         0x2E000000
#define ASHBROOK_NON_SECURE_SRAM_SZ           SIZE_32KB

// GIC-500
#define ASHBROOK_GIC_500_BASE                 0x30000000
#define ASHBROOK_GIC_500_BASE_SZ              SIZE_256KB

//#define ASHBROOK_GIC_500_RBASE                0x30800000
#define ASHBROOK_GIC_500_RBASE_SZ             SIZE_8MB

// SOC peripherals (HDLCD, UART, I2C, I2S, SMC-PL354, etc)
#define ASHBROOK_SOC_PERIPHERALS_BASE         0x7FF50000
#define ASHBROOK_SOC_PERIPHERALS_SZ           (SIZE_64KB * 10)

// 16 MB ARM-TF System Memory
#define ASHBROOK_ARM_TF_SYSTEM_MEMORY_BASE    0xFF000000
#define ASHBROOK_ARM_TF_SYSTEM_MEMORY_SZ      SIZE_16MB

// Extra DRAM
// FVP supports 1 more bank of DRAM from 0x8 8000 0000.
// Emulator/TB have not implemented this bank
// Hence use 1 GB (approx) from 0xC000 0000
#define ASHBROOK_EXTRA_SYSTEM_MEMORY_BASE     0xC0000000
#define ASHBROOK_EXTRA_SYSTEM_MEMORY_SZ       (SIZE_1GB - SIZE_16MB)

//
// ACPI table information used to initialize tables.
//
#define EFI_ACPI_ARM_OEM_ID           'A','R','M','L','T','D'   // OEMID 6 bytes long
#define EFI_ACPI_ARM_OEM_TABLE_ID     SIGNATURE_64('A','S','H','B','R','O','O','K') // OEM table id 8 bytes long
#define EFI_ACPI_ARM_OEM_REVISION     0x20140727
#define EFI_ACPI_ARM_CREATOR_ID       SIGNATURE_32('A','R','M',' ')
#define EFI_ACPI_ARM_CREATOR_REVISION 0x00000099

// A macro to initialise the common header part of EFI ACPI tables as defined by
// EFI_ACPI_DESCRIPTION_HEADER structure.
#define ARM_ACPI_HEADER(Signature, Type, Revision) {              \
    Signature,                      /* UINT32  Signature */       \
    sizeof (Type),                  /* UINT32  Length */          \
    Revision,                       /* UINT8   Revision */        \
    0,                              /* UINT8   Checksum */        \
    { EFI_ACPI_ARM_OEM_ID },        /* UINT8   OemId[6] */        \
    EFI_ACPI_ARM_OEM_TABLE_ID,      /* UINT64  OemTableId */      \
    EFI_ACPI_ARM_OEM_REVISION,      /* UINT32  OemRevision */     \
    EFI_ACPI_ARM_CREATOR_ID,        /* UINT32  CreatorId */       \
    EFI_ACPI_ARM_CREATOR_REVISION   /* UINT32  CreatorRevision */ \
  }

#define ASHBROOK_WATCHDOG_COUNT  2

#endif
