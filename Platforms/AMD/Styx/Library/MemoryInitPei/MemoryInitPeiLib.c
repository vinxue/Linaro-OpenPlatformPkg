/** @file

  Copyright (c) 2011-2014, ARM Limited. All rights reserved.<BR>
  Copyright (c) 2014 - 2016 AMD Inc. All rights reserved.<BR>

  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/
/**
  Derived from:
   ArmPlatformPkg/MemoryInitPei/MemoryInitPeiLib.c

**/

#include <PiPei.h>

#include <Library/ArmMmuLib.h>
#include <Library/ArmPlatformLib.h>
#include <Library/BaseMemoryLib.h>
#include <Library/DebugLib.h>
#include <Library/HobLib.h>
#include <Library/MemoryAllocationLib.h>
#include <Library/PcdLib.h>

VOID
BuildMemoryTypeInformationHob (
  VOID
  );

STATIC ARM_MEMORY_REGION_DESCRIPTOR  mMemoryTable[] = {
  {
    // Mapped I/O space
    0xE0000000UL,
    0xE0000000UL,
    SIZE_256MB,
    ARM_MEMORY_REGION_ATTRIBUTE_DEVICE
  }, {
    // PCI config space
    0xF0000000UL,
    0xF0000000UL,
    SIZE_256MB,
    ARM_MEMORY_REGION_ATTRIBUTE_DEVICE
  }, {
    // DRAM
    FixedPcdGet64 (PcdSystemMemoryBase),
    FixedPcdGet64 (PcdSystemMemoryBase),
    0,
    ARM_MEMORY_REGION_ATTRIBUTE_WRITE_BACK
  }, {
  }
};

#if !defined(MDEPKG_NDEBUG)

static const char *tblAttrDesc[] =
{
  "UNCACHED_UNBUFFERED          ",
  "NONSECURE_UNCACHED_UNBUFFERED",
  "WRITE_BACK                   ",
  "NONSECURE_WRITE_BACK         ",
  "WRITE_THROUGH                ",
  "NONSECURE_WRITE_THROUGH      ",
  "DEVICE                       ",
  "NONSECURE_DEVICE             "
};
#endif

#define LOG_MEM(Index, Desc) \
  DEBUG ((DEBUG_INIT,                                                   \
    Desc,                                                               \
    mMemoryTable[Index].PhysicalBase,                                   \
    mMemoryTable[Index].PhysicalBase + mMemoryTable[Index].Length - 1,  \
    mMemoryTable[Index].Length,                                         \
    tblAttrDesc[mMemoryTable[Index].Attributes]                         \
    ));

VOID
InitMmu (
  VOID
  )
{
  VOID                          *TranslationTableBase;
  UINTN                         TranslationTableSize;
  RETURN_STATUS                 Status;

  mMemoryTable[2].Length = PcdGet64 (PcdSystemMemorySize);

  DEBUG ((DEBUG_INIT,
    "Memory Map\n"
    "------------------------------------------------------------------------\n"
    "Description                    :        START       -        END         [        SIZE        ]    {              ATTR             }\n"
    ));

  LOG_MEM (0,
    "I/O Space [Platform MMIO]      : 0x%016lx - 0x%016lx [ 0x%016lx ]    { %a }\n");
  LOG_MEM (1,
    "I/O Space [PCI config space]   : 0x%016lx - 0x%016lx [ 0x%016lx ]    { %a }\n");
  LOG_MEM (2,
    "DRAM                           : 0x%016lx - 0x%016lx [ 0x%016lx ]    { %a }\n");

  // Note: Because we called PeiServicesInstallPeiMemory() before to call
  //       InitMmu() the MMU Page Table resides in DRAM (even at the top
  //       of DRAM as it is the first permanent memory allocation)
  Status = ArmConfigureMmu (mMemoryTable, &TranslationTableBase,
             &TranslationTableSize);
  if (EFI_ERROR (Status)) {
    DEBUG ((EFI_D_ERROR, "Error: Failed to enable MMU\n"));
  }
}

STATIC
VOID
MoveNvStoreImage (
  VOID
  )
{
  VOID      *OldBase, *NewBase;
  UINTN     Size;

  //
  // Move the in-memory image of the NV store firmware volume to a dynamically
  // allocated buffer. This gets rid of the annoying static memory reservation
  // at the base of memory where all other UEFI allocations are near the top.
  //
  OldBase = (VOID *)FixedPcdGet64 (PcdFlashNvStorageOriginalBase);

  Size = FixedPcdGet32 (PcdFlashNvStorageVariableSize) +
         FixedPcdGet32 (PcdFlashNvStorageFtwWorkingSize) +
         FixedPcdGet32 (PcdFlashNvStorageFtwSpareSize);

  NewBase = AllocateAlignedRuntimePages (EFI_SIZE_TO_PAGES (Size), SIZE_64KB);
  ASSERT (NewBase != NULL);

  CopyMem (NewBase, OldBase, Size);

  DEBUG ((EFI_D_INFO, "%a: Relocating NV store FV from %p to %p\n",
    __FUNCTION__, OldBase, NewBase));

  PcdSet64 (PcdFlashNvStorageVariableBase64, (UINT64)NewBase);

  PcdSet64 (PcdFlashNvStorageFtwWorkingBase64, (UINT64)NewBase +
    FixedPcdGet32 (PcdFlashNvStorageVariableSize));

  PcdSet64 (PcdFlashNvStorageFtwSpareBase64, (UINT64)NewBase +
    FixedPcdGet32 (PcdFlashNvStorageVariableSize) +
    FixedPcdGet32 (PcdFlashNvStorageFtwWorkingSize));
}

/*++

Routine Description:



Arguments:

  FileHandle  - Handle of the file being invoked.
  PeiServices - Describes the list of possible PEI Services.

Returns:

  Status -  EFI_SUCCESS if the boot mode could be set

--*/
EFI_STATUS
EFIAPI
MemoryPeim (
  IN EFI_PHYSICAL_ADDRESS               UefiMemoryBase,
  IN UINT64                             UefiMemorySize
  )
{
  UINT64  Base, Size;

  // Ensure PcdSystemMemorySize has been set
  ASSERT (PcdGet64 (PcdSystemMemorySize) != 0);

  //
  // Now, the permanent memory has been installed, we can call AllocatePages()
  //

  Base = PcdGet64 (PcdSystemMemoryBase);
  Size = PcdGet64 (PcdSystemMemorySize);
  if (FixedPcdGetBool (PcdTrustedFWSupport)) {

    //
    // For now, we assume that the trusted firmware region is at the base of
    // system memory, since that is much easier to deal with.
    //
    ASSERT (Base == PcdGet64 (PcdTrustedFWMemoryBase));

    Base += PcdGet64 (PcdTrustedFWMemorySize);
    Size -= PcdGet64 (PcdTrustedFWMemorySize);

    // Reserved Trusted Firmware region
    BuildResourceDescriptorHob (
        EFI_RESOURCE_SYSTEM_MEMORY,
      ( EFI_RESOURCE_ATTRIBUTE_PRESENT |
        EFI_RESOURCE_ATTRIBUTE_INITIALIZED |
        EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE |
        EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE |
        EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE |
        EFI_RESOURCE_ATTRIBUTE_TESTED ),
        PcdGet64 (PcdTrustedFWMemoryBase),
        PcdGet64 (PcdTrustedFWMemorySize)
      );

      BuildMemoryAllocationHob (
        PcdGet64 (PcdTrustedFWMemoryBase),
        PcdGet64 (PcdTrustedFWMemorySize),
        EfiReservedMemoryType
      );
  }

  // Declare system memory
  BuildResourceDescriptorHob (
      EFI_RESOURCE_SYSTEM_MEMORY,
    ( EFI_RESOURCE_ATTRIBUTE_PRESENT |
      EFI_RESOURCE_ATTRIBUTE_INITIALIZED |
      EFI_RESOURCE_ATTRIBUTE_WRITE_COMBINEABLE |
      EFI_RESOURCE_ATTRIBUTE_WRITE_THROUGH_CACHEABLE |
      EFI_RESOURCE_ATTRIBUTE_WRITE_BACK_CACHEABLE |
      EFI_RESOURCE_ATTRIBUTE_TESTED ),
      Base,
      Size
  );

  // Build Memory Allocation Hob
  InitMmu ();

  // Optional feature that helps prevent EFI memory map fragmentation.
  if (FeaturePcdGet (PcdPrePiProduceMemoryTypeInformationHob)) {
    BuildMemoryTypeInformationHob ();
  }

  MoveNvStoreImage ();

  return EFI_SUCCESS;
}
