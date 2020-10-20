/*
 Copyright © Allan Paiste. All rights reserved.
 See LICENSE.txt for license details.
*/
import * as React from 'react';

import { Text, TextProps } from './Themed';

export function MonoText(props: TextProps) {
  return <Text {...props} style={[props.style, { fontFamily: 'space-mono' }]} />;
}
