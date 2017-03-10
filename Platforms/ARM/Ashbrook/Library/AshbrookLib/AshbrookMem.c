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

#include <Library/ArmPlatformLib.h>
#include <Library/DebugLib.h>
#include <Library/HobLib.h>
#include <Library/PcdLib.h>
#include <Library/IoLib.h>
#include <Library/MemoryAllocationLib.h>

#include <ArmPlatform.h>

// The total number of descriptors, including the final "end-of-table" descriptor.
#define MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS 16

// DDR attributes
#define DDR_ATTRIBUTES_CACHED           ARM_MEMORY_REGION_ATTRIBUTE_WRITE_BACK
#define DDR_ATTRIBUTES_UNCACHED         ARM_MEMORY_REGION_ATTRIBUTE_UNCACHED_UNBUFFERED

/**
  Return the Virtual Memory Map of your platform

  This Virtual Memory Map is used by MemoryInitPei Module to initialize the MMU on your platform.

  @param[out]   VirtualMemoryMap    Array of ARM_MEMORY_REGION_DESCRIPTOR describing a Physical-to-
                                    Virtual Memory mapping. This array must be ended by a zero-filled
                                    entry

**/
VOID
ArmPlatformGetVirtualMemoryMap (
  IN ARM_MEMORY_REGION_DESCRIPTOR** VirtualMemoryMap
  )
{
  ARM_MEMORY_REGION_ATTRIBUTES  CacheAttributes;
  UINTN                         Index = 0;
  ARM_MEMORY_REGION_DESCRIPTOR  *VirtualMemoryTable;
  EFI_RESOURCE_ATTRIBUTE_TYPE   ResourceAttributes;

  ASSERT (VirtualMemoryMap != NULL);

  //
  // Declared the additional 6GB of memory
  //
  ResourceAttributes =
      EFI_RESOURCE_ATTRIBUTE_PRESENT |
      EFI_RESOURCE_ATTRIBUTE_INITIALIZED |
      EFI_RESOURCE_ATTRIBUTE_UNCACHEABLE |
      EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE |
      EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE |
      EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE |
      EFI_RESOURCE_ATTRIBUTE_TESTED;

  BuildResourceDescriptorHob (
    EFI_RESOURCE_SYSTEM_MEMORY,
    ResourceAttributes,
    ASHBROOK_EXTRA_SYSTEM_MEMORY_BASE,
    ASHBROOK_EXTRA_SYSTEM_MEMORY_SZ);

  VirtualMemoryTable = (ARM_MEMORY_REGION_DESCRIPTOR*)AllocatePages(EFI_SIZE_TO_PAGES (sizeof(ARM_MEMORY_REGION_DESCRIPTOR) * MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS));
  if (VirtualMemoryTable == NULL) {
      return;
  }

  if (FeaturePcdGet(PcdCacheEnable) == TRUE) {
      CacheAttributes = DDR_ATTRIBUTES_CACHED;
  } else {
      CacheAttributes = DDR_ATTRIBUTES_UNCACHED;
  }

  // SMB CS0 - NOR0 Flash
  VirtualMemoryTable[Index].PhysicalBase    = ARM_VE_SMB_NOR0_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ARM_VE_SMB_NOR0_BASE;
  VirtualMemoryTable[Index].Length          = SIZE_256KB * 255;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;
  // Environment Variables region
  VirtualMemoryTable[++Index].PhysicalBase  = ARM_VE_SMB_NOR0_BASE + (SIZE_256KB * 255);
  VirtualMemoryTable[Index].VirtualBase     = ARM_VE_SMB_NOR0_BASE + (SIZE_256KB * 255);
  VirtualMemoryTable[Index].Length          = SIZE_64KB * 4;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // SMB CS2 & CS3 - Off-chip (motherboard) peripherals
  VirtualMemoryTable[++Index].PhysicalBase  = ARM_VE_SMB_PERIPH_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ARM_VE_SMB_PERIPH_BASE;
  VirtualMemoryTable[Index].Length          = ARM_VE_SMB_PERIPH_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // Off-chip (motherboard) System Registers
  VirtualMemoryTable[++Index].PhysicalBase  = ARM_VE_BOARD_PERIPH_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ARM_VE_BOARD_PERIPH_BASE;
  VirtualMemoryTable[Index].Length          = ARM_VE_BOARD_PERIPH_BASE_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // Ashbrook OnChip non-secure ROM
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_NON_SECURE_ROM_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_NON_SECURE_ROM_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_NON_SECURE_ROM_SZ;
  VirtualMemoryTable[Index].Attributes      = CacheAttributes;

  // Ashbrook OnChip peripherals
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_PERIPHERALS_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_PERIPHERALS_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_PERIPHERALS_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // Ashbrook OnChip non-secure SRAM
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_NON_SECURE_SRAM_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_NON_SECURE_SRAM_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_NON_SECURE_SRAM_SZ;
  VirtualMemoryTable[Index].Attributes      = CacheAttributes;

  // Ashbrook GIC-500
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_GIC_500_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_GIC_500_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_GIC_500_BASE_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  VirtualMemoryTable[++Index].PhysicalBase  = PcdGet32 (PcdGicRedistributorsBase);
  VirtualMemoryTable[Index].VirtualBase     = PcdGet32 (PcdGicRedistributorsBase);
  VirtualMemoryTable[Index].Length          = ASHBROOK_GIC_500_RBASE_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // Ashbrook SOC peripherals
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_SOC_PERIPHERALS_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_SOC_PERIPHERALS_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_SOC_PERIPHERALS_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // DDR - 1 GB
  VirtualMemoryTable[++Index].PhysicalBase  = PcdGet64 (PcdSystemMemoryBase);
  VirtualMemoryTable[Index].VirtualBase     = PcdGet64 (PcdSystemMemoryBase);
  VirtualMemoryTable[Index].Length          = PcdGet64 (PcdSystemMemorySize);
  VirtualMemoryTable[Index].Attributes      = CacheAttributes;

  // Extra DDR - (1GB - 16MB)
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_EXTRA_SYSTEM_MEMORY_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_EXTRA_SYSTEM_MEMORY_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_EXTRA_SYSTEM_MEMORY_SZ;
  VirtualMemoryTable[Index].Attributes      = CacheAttributes;

  // ARM-TF - 16 MB
  VirtualMemoryTable[++Index].PhysicalBase  = ASHBROOK_ARM_TF_SYSTEM_MEMORY_BASE;
  VirtualMemoryTable[Index].VirtualBase     = ASHBROOK_ARM_TF_SYSTEM_MEMORY_BASE;
  VirtualMemoryTable[Index].Length          = ASHBROOK_ARM_TF_SYSTEM_MEMORY_SZ;
  VirtualMemoryTable[Index].Attributes      = ARM_MEMORY_REGION_ATTRIBUTE_DEVICE;

  // End of Table
  VirtualMemoryTable[++Index].PhysicalBase  = 0;
  VirtualMemoryTable[Index].VirtualBase     = 0;
  VirtualMemoryTable[Index].Length          = 0;
  VirtualMemoryTable[Index].Attributes      = (ARM_MEMORY_REGION_ATTRIBUTES)0;

  ASSERT((Index + 1) <= MAX_VIRTUAL_MEMORY_MAP_DESCRIPTORS);

  *VirtualMemoryMap = VirtualMemoryTable;
}
