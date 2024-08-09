﻿# Monkey365 - the PowerShell Cloud Security Tool for Azure and Microsoft 365 (copyright 2022) by Juan Garrido
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


function Get-MonkeyM365ThirdPartyStorageConfig {
<#
        .SYNOPSIS
		Collector to get information about third party storage settings in Microsoft 365

        .DESCRIPTION
		Collector to get information about third party storage settings in Microsoft 365

        .INPUTS

        .OUTPUTS

        .EXAMPLE

        .NOTES
	        Author		: Juan Garrido
            Twitter		: @tr1ana
            File Name	: Get-MonkeyM365ThirdPartyStorageConfig
            Version     : 1.0

        .LINK
            https://github.com/silverhack/monkey365
    #>

	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $false,HelpMessage = "Background Collector ID")]
		[string]$collectorId
	)
	begin {
		#Collector metadata
		$monkey_metadata = @{
			Id = "m365admin003";
			Provider = "Microsoft365";
			Resource = "Microsoft365";
			ResourceType = $null;
			resourceName = $null;
			collectorName = "Get-MonkeyM365ThirdPartyStorageConfig";
			ApiType = "MSGraph";
			description = "Collector to get information about third party storage settings in Microsoft 365";
			Group = @(
				"Microsoft365"
			);
			Tags = @{
				"enabled" = $true
			};
			Docs = "https://silverhack.github.io/monkey365/";
			ruleSuffixes = @(
				"m365_thirdparty_app"
			);
			dependsOn = @(

			);
		}
		#Get Config
		try {
			$aadConf = $O365Object.internal_config.entraId.Provider.msgraph
		}
		catch {
			$msg = @{
				MessageData = ($message.MonkeyInternalConfigError);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = 'verbose';
				InformationAction = $O365Object.InformationAction;
				Tags = @('Monkey365ConfigError');
			}
			Write-Verbose @msg
			break
		}
		$app = $null
	}
	process {
		$msg = @{
			MessageData = ($message.MonkeyGenericTaskMessage -f $collectorId,"Microsoft MSGraph applications",$O365Object.TenantID);
			callStack = (Get-PSCallStack | Select-Object -First 1);
			logLevel = 'info';
			InformationAction = $O365Object.InformationAction;
			Tags = @('MSGraphApplicationInfo');
		}
		Write-Information @msg
		$p = @{
			APIVersion = $aadConf.api_version;
            Filter = "appId eq 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'";
			InformationAction = $O365Object.InformationAction;
			Verbose = $O365Object.Verbose;
			Debug = $O365Object.Debug;
		}
		$app = Get-MonkeyMSGraphAADServicePrincipal @p
	}
	end {
		if ($null -ne $app) {
			$app.PSObject.TypeNames.Insert(0,'Monkey365.MSGraph.ThirdPartyApp')
			[pscustomobject]$obj = @{
				Data = $app;
				Metadata = $monkey_metadata;
			}
			$returnData.m365_thirdparty_app = $obj;
		}
		else {
			$msg = @{
				MessageData = ($message.MonkeyEmptyResponseMessage -f "Microsoft MSGraph applications",$O365Object.TenantID);
				callStack = (Get-PSCallStack | Select-Object -First 1);
				logLevel = "verbose";
				InformationAction = $O365Object.InformationAction;
				Verbose = $O365Object.Verbose;
				Tags = @('MSGraphApplicationEmptyMessage')
			}
			Write-Verbose @msg
		}
	}
}