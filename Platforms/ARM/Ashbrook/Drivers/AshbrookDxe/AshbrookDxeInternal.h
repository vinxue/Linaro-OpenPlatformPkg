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

#ifndef __ASHBROOK_DXE_INTERNAL_H__
#define __ASHBROOK_DXE_INTERNAL_H__

#include <Uefi.h>

#include <Library/AcpiLib.h>
#include <Library/DebugLib.h>
#include <Library/DxeServicesTableLib.h>
#include <Library/UefiBootServicesTableLib.h>

#include <IndustryStandard/Acpi.h>

EFI_STATUS
InitDramBlockIo (
  VOID
  );

EFI_STATUS
AshbrookFdtInstall (
  IN EFI_HANDLE  ImageHandle
  );

#endif // __ASHBROOK_DXE_INTERNAL_H__
