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
            column(vpos; vpos)
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
                clear(vpos);
                if Level <> 0 then begin

                    RecProductionBOMLine.Reset();
                    RecProductionBOMLine.SetRange("Production BOM No.", BomComponent[Level]."Production BOM No.");
                    RecProductionBOMLine.SetRange("No.", BomComponent[Level]."No.");
                    if RecProductionBOMLine.FindFirst() then begin
                        vpos := RecProductionBOMLine.Position;
                        RecProdBOMCommentLine.Reset();
                        RecProdBOMCommentLine.SetRange("Production BOM No.", BomComponent[Level]."Production BOM No.");
                        RecProdBOMCommentLine.SetRange("BOM Line No.", RecProductionBOMLine."Line No.");

                        if RecProdBOMCommentLine.FindSet() then
                            repeat
                                IF Comments = '' then
                                    Comments := RecProdBOMCommentLine.Comment
                                else begin
                                    Comments := Comments + ', ' + RecProdBOMCommentLine.Comment;
                                end;
                            until RecProdBOMCommentLine.Next() = 0;

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
        Comments: text[1000];
        vpos: code[20];



}