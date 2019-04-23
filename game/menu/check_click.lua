return function(area, click)
    return click.x >= area.x and click.x <= (area.x + area.width) and click.y >= area.y and click.y <= (area.y + area.height)
end
