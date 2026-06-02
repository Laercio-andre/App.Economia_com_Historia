// src/main/java/com/economiangola/domain/entity/Tag.java
package com.economiangola.domain.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "tags")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Tag extends BaseEntity {

    @Column(name = "nome", nullable = false, unique = true, length = 50)
    private String nome;

    @Column(name = "slug", nullable = false, unique = true, length = 80)
    private String slug;
}
