Function New-HaloSupplierBatch {
    <#
        .SYNOPSIS
            Creates multiple suppliers via the Halo API.
        .DESCRIPTION
            Function to send a batch of supplier creation requests to the Halo API
        .OUTPUTS
            Outputs an object containing the responses from the web requests.
    #>
    [CmdletBinding( SupportsShouldProcess = $True )]
    [OutputType([Object[]])]
    Param (
        # Array of objects containing properties and values used to create one or more new suppliers.
        [Parameter( Mandatory = $True )]
        [Array[]]$Suppliers,
        # How many objects to process at once before delaying. Default value is 100.
        [Int32]$BatchSize,
        # How long to wait between batch runs. Default value is 1 second.
        [Int32]$BatchWait
    )
    Invoke-HaloPreFlightCheck
    try {
        if ($PSCmdlet.ShouldProcess('Suppliers', 'Create')) {
            if ($Suppliers -is [Array]) {
                $BatchParams = @{
                    BatchInput = $Suppliers
                    EntityType = 'Supplier'
                    Operation = 'New'
                }
                if ($BatchSize) {
                    $BatchParams.Size = $BatchSize
                }
                if ($BatchWait) {
                    $BatchParams.Wait = $BatchWait
                }
                $BatchResults = Invoke-HaloBatchProcessor @BatchParams
                Return $BatchResults
            } else {
                throw 'New-HaloSupplierBatch requires an array of suppliers to create.'
            }  
        }
    } catch {
        New-HaloError -ErrorRecord $_
    }
}