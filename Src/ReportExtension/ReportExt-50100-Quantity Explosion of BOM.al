reportextension 50100 QuantityExplosionofBOMExt extends "Quantity Explosion of BOM"
{
    dataset
    {
        // Add changes to dataitems and columns here
        add(Integer)
        {
            column(Comments; Comments)
            {

            }
        }
        modify(BOMLoop)
        {
            trigger OnAfterAfterGetRecord()
            var
                myInt: Integer;
                RecProdBOMCommentLine: Record "Production BOM Comment Line";
                RecProductionBOMLine: Record "Production BOM Line";
                RecProdBomHdr: Record "Production BOM Header";

            begin
                Clear(Comments);
                if Level <> 0 then begin

                    RecProductionBOMLine.Reset();
                    RecProductionBOMLine.SetRange("Production BOM No.", BomComponent[Level]."Production BOM No.");
                    RecProductionBOMLine.SetRange("No.", BomComponent[Level]."No.");
                    if RecProductionBOMLine.FindFirst() then begin

                        RecProdBOMCommentLine.Reset();
                        RecProdBOMCommentLine.SetRange("Production BOM No.", BomComponent[Level]."Production BOM No.");
                        RecProdBOMCommentLine.SetRange("BOM Line No.", RecProductionBOMLine."Line No.");
                     
                        if RecProdBOMCommentLine.FindSet() then
                            Comments := RecProdBOMCommentLine.Comment;
                       
                    end;

                end;
            end;
        }
    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    var
        Comments: text[200];




}