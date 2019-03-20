return function(graphics, fonts)
    local font
    return function(drawable)
        drawable = drawable or {}
        graphics.setColor(drawable.red or 0, drawable.green or 0, drawable.blue or 0, drawable.alpha or 100)
        if drawable.string then
            font = fonts[drawable.font]
            graphics.setFont(font)
            graphics.print(
                drawable.string, 
                drawable.x, 
                drawable.y, 
                nil, nil, nil, 
                font:getWidth(drawable.string)/2, 
                font:getHeight()/2)

        elseif drawable.r then
            graphics.circle(drawable.mode, drawable.x, drawable.y, drawable.r)
        elseif drawable.width then
            graphics.rectangle(drawable.mode, drawable.x, drawable.y, drawable.width, drawable.height)
        elseif drawable.x1 then
            graphics.polygon(
                drawable.mode,
                drawable.x1,
                drawable.y1,
                drawable.x2,
                drawable.y2,
                drawable.x3,
                drawable.y3)
        end
    end
end
