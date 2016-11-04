/** @file
  Copyright (c) 2016, Linaro, Ltd. All rights reserved.<BR>

  This program and the accompanying materials
  are licensed and made available under the terms and conditions of the BSD License
  which accompanies this distribution.  The full text of the license may be found at
  http://opensource.org/licenses/bsd-license.php

  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

**/
#include <PiDxe.h>

#include <Library/BaseLib.h>
#include <Library/DebugLib.h>
#include <Library/NonDiscoverableDeviceRegistrationLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/HobLib.h>
#include <libfdt.h>

#include <Guid/Fdt.h>
#include <Guid/FdtHob.h>

STATIC CONST EFI_PHYSICAL_ADDRESS SdhciBaseAddress = 0x3f202000;

/**
  @param  ImageHandle   of the loaded driver
  @param  SystemTable   Pointer to the System Table

  @retval EFI_SUCCESS           Protocol registered
  @retval EFI_OUT_OF_RESOURCES  Cannot allocate protocol data structure
  @retval EFI_DEVICE_ERROR      Hardware problems

**/
EFI_STATUS
EFIAPI
RaspberryPiPlatformDxeInitialize (
  IN EFI_HANDLE         ImageHandle,
  IN EFI_SYSTEM_TABLE   *SystemTable
  )
{
  VOID              *Hob;
  VOID              *DeviceTreeBase;
  EFI_STATUS        Status;

  Hob = GetFirstGuidHob (&gFdtHobGuid);
  if (Hob == NULL || GET_GUID_HOB_DATA_SIZE (Hob) != sizeof (UINT64)) {
    return EFI_NOT_FOUND;
  }
  DeviceTreeBase = (VOID *)(UINTN)*(UINT64 *)GET_GUID_HOB_DATA (Hob);

  if (fdt_check_header (DeviceTreeBase) != 0) {
    DEBUG ((EFI_D_ERROR, "%a: No DTB found @ 0x%p\n", __FUNCTION__,
      DeviceTreeBase));
    return EFI_NOT_FOUND;
  }

  DEBUG ((EFI_D_INFO, "%a: DTB @ 0x%p\n", __FUNCTION__, DeviceTreeBase));

  Status = gBS->InstallConfigurationTable (&gFdtTableGuid, DeviceTreeBase);
  ASSERT_EFI_ERROR (Status);

  return RegisterNonDiscoverableDevice (
           SdhciBaseAddress,
           NonDiscoverableDeviceTypeSdhci,
           NonDiscoverableDeviceDmaTypeNonCoherent,
           NULL,
           NULL);
}
